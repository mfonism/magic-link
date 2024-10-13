module API.HealthCheckSpec (handlerSpec) where

import API.HealthCheck (HealthCheckResponse (..))
import App (mkApp)
import App.Context qualified as AppContext
import Network.HTTP.Types (status200)
import Test.Hspec
import TestUtils (assertJsonContentType, assertStatus, decodeJsonResponse, runRequest)

handlerSpec :: Spec
handlerSpec = describe "GET /health-check" $ do
  appCtx <- runIO AppContext.initialize
  let app = mkApp appCtx

  it "responds with JSON containing health status" $ do
    response <- runRequest "/health-check" app
    assertStatus status200 response
    assertJsonContentType response

    decodedResponse <- decodeJsonResponse response
    decodedResponse `shouldBe` HealthCheckResponse True
