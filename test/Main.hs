{-# LANGUAGE OverloadedStrings #-}

module Main where

import API.Signup.HandlerSpec qualified
import App (HelloResponse (..), app)
import Network.HTTP.Types (status200)
import Test.Hspec
import TestUtils (assertJsonContentType, assertStatus, decodeJsonResponse, runRequest)

main :: IO ()
main = hspec $ do
  helloSpec
  API.Signup.HandlerSpec.handlerSpec

helloSpec :: Spec
helloSpec = describe "GET /hello" $ do
  it "responds with JSON containing 'Hello, Magic Link!'" $ do
    response <- runRequest "/hello" app
    assertStatus status200 response
    assertJsonContentType response

    decodedResponse <- decodeJsonResponse response
    decodedResponse `shouldBe` HelloResponse "Hello, Magic Link!"
