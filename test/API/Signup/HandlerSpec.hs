{-# LANGUAGE DisambiguateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}

module API.Signup.HandlerSpec where

import API.Signup.Request (SignupRequest (..))
import API.Signup.Response (SignupResponse (..))
import App (app)
import Network.HTTP.Types (status200)
import Test.Hspec
import TestUtils (assertJsonContentType, assertStatus, decodeJsonResponse, runPostRequest)

handlerSpec :: Spec
handlerSpec = describe "POST /signup" $ do
  it "responds with JSON indicating that a signup request has been addressed" $ do
    let signupRequest = SignupRequest "magic@link.poof"
    response <- runPostRequest "/signup" signupRequest app
    assertStatus status200 response
    assertJsonContentType response

    decodedResponse <- decodeJsonResponse response
    decodedResponse
      `shouldBe` SignupResponse
        { email = "magic@link.poof",
          magicLinkSent = True
        }
