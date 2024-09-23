{-# LANGUAGE OverloadedStrings #-}

module TestUtils
  ( assertStatus,
    assertJsonContentType,
    decodeJsonResponse,
    runRequest,
  )
where

import Data.Aeson qualified
import Data.ByteString qualified as BS
import Data.ByteString.Char8 qualified as B8
import Data.ByteString.Lazy.Char8 qualified as BL8
import Network.HTTP.Types (Status, hContentType)
import Network.Wai.Test (SResponse, defaultRequest, request, runSession, setPath, simpleBody, simpleHeaders, simpleStatus)
import Servant
import Test.Hspec (Expectation, shouldBe, shouldSatisfy)

type Path = String

runRequest :: Path -> Application -> IO SResponse
runRequest path app = do
  let req = setPath defaultRequest (B8.pack path)
  runSession (request req) app

assertStatus :: Status -> SResponse -> Expectation
assertStatus expectedStatus response =
  simpleStatus response `shouldBe` expectedStatus

assertJsonContentType :: SResponse -> Expectation
assertJsonContentType response =
  lookup hContentType (simpleHeaders response)
    `shouldSatisfy` maybe False (BS.isInfixOf "application/json")

decodeJsonResponse :: (Data.Aeson.FromJSON a, Show a) => SResponse -> IO a
decodeJsonResponse response = do
  let responseBody = simpleBody response
  case Data.Aeson.decode responseBody of
    Just decodedResponse -> return decodedResponse
    Nothing ->
      fail $
        "Failed to decode response body. Raw response:\n"
          ++ BL8.unpack responseBody
