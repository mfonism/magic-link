{-# LANGUAGE OverloadedStrings #-}

module Main where

import MyLib (HelloResponse (..), app)
import Network.HTTP.Types (status200)
import Test.Hspec
import TestUtils (assertJsonContentType, assertStatus, decodeJsonResponse, runRequest)

main :: IO ()
main = hspec spec

spec :: Spec
spec = describe "GET /hello" $ do
  it "responds with JSON containing 'Hello, Magic Link!'" $ do
    response <- runRequest "/hello" app
    assertStatus status200 response
    assertJsonContentType response

    decodedResponse <- decodeJsonResponse response
    decodedResponse `shouldBe` HelloResponse "Hello, Magic Link!"
