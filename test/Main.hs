{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson (encode)
import Data.ByteString qualified as BS
import MyLib (HelloResponse (..), app)
import Network.HTTP.Types (hContentType, status200)
import Network.Wai.Test (defaultRequest, request, runSession, setPath, simpleBody, simpleHeaders, simpleStatus)
import Test.Hspec

main :: IO ()
main = hspec spec

spec :: Spec
spec = describe "GET /hello" $ do
  it "responds with JSON containing 'Hello, Magic Link!'" $ do
    let req = setPath defaultRequest "/hello"
    response <- runSession (request req) app

    simpleStatus response `shouldBe` status200
    lookup hContentType (simpleHeaders response) `shouldSatisfy` maybe False (BS.isInfixOf "application/json")

    let expectedJson = encode $ HelloResponse "Hello, Magic Link!"
    simpleBody response `shouldBe` expectedJson
