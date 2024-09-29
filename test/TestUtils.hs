{-# LANGUAGE OverloadedStrings #-}

module TestUtils
  ( assertStatus,
    assertJsonContentType,
    decodeJsonResponse,
    runRequest,
    runPostRequest,
  )
where

import Data.Aeson qualified
import Data.ByteString qualified as BS
import Data.ByteString.Char8 qualified as B8
import Data.ByteString.Lazy.Char8 qualified as BL8
import Network.HTTP.Types (Status, hContentType)
import Network.Wai (Request (requestHeaders, requestMethod))
import Network.Wai.Test (SRequest (..), SResponse, defaultRequest, request, runSession, setPath, simpleBody, simpleHeaders, simpleStatus, srequest)
import Servant
import Test.Hspec (Expectation, shouldBe, shouldSatisfy)

type Path = String

runRequest :: Path -> Application -> IO SResponse
runRequest path app = do
  let req = setPath defaultRequest (B8.pack path)
  runSession (request req) app

runPostRequest :: (Data.Aeson.ToJSON a) => Path -> a -> Application -> IO SResponse
runPostRequest path body app = do
  let req =
        defaultRequest
          { requestMethod = "POST",
            requestHeaders = [("Content-Type", "application/json")]
          }
      req' = setPath req (B8.pack path)
      sreq =
        SRequest
          { simpleRequest = req',
            simpleRequestBody = Data.Aeson.encode body
          }
      session = srequest sreq
  runSession session app

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
