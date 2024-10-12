{-# LANGUAGE OverloadedStrings #-}

module API.HealthCheckSpec (handlerSpec) where

import API.HealthCheck (HealthCheckResponse (..))
import App (app)
import Network.HTTP.Types (status200)
import Test.Hspec
import TestUtils (assertJsonContentType, assertStatus, decodeJsonResponse, runRequest)

handlerSpec :: Spec
handlerSpec = describe "GET /health-check" $ do
  it "responds with JSON containing health status" $ do
    response <- runRequest "/health-check" app
    assertStatus status200 response
    assertJsonContentType response

    decodedResponse <- decodeJsonResponse response
    decodedResponse `shouldBe` HealthCheckResponse True
