{-# LANGUAGE DisambiguateRecordFields #-}

module API.Signup.HandlerSpec where

import API.Signup.Request (SignupRequest (..))
import API.Signup.Response (SignupFailureReason (..), SignupResponse (..))
import App (app)
import Control.Monad (forM_)
import Network.HTTP.Types (status200)
import Test.Hspec
import TestUtils (assertJsonContentType, assertStatus, decodeJsonResponse, runPostRequest)
import Text.Email.Validate qualified as EmailValidate

handlerSpec :: Spec
handlerSpec =
  describe "POST /signup" $ do
    handleSignupForValidEmail
    handleSignupForInvalidEmail

handleSignupForValidEmail :: Spec
handleSignupForValidEmail =
  it "responds with JSON indicating that a signup request has been addressed" $ do
    let signupRequest = SignupRequest "magic@link.poof"
    response <- runPostRequest "/signup" signupRequest app
    assertStatus status200 response
    assertJsonContentType response

    decodedResponse <- decodeJsonResponse response
    decodedResponse
      `shouldBe` SignupSuccess (EmailValidate.unsafeEmailAddress "magic" "link.poof")

handleSignupForInvalidEmail :: Spec
handleSignupForInvalidEmail =
  describe "with invalid email addresses" $ do
    let invalidEmails =
          [ "plainaddress", -- Missing @ symbol
            "@example.com", -- Missing local part (username) before @
            "john@@example.com", -- Multiple @ symbols
            ".john@example.com", -- Leading dot in the local part
            "john.@example.com", -- Trailing dot in the local part
            "john..doe@example.com", -- Consecutive dots in the local part
            "john.doe@example.com#", -- Invalid character (#) in the local part
            "john.doe@", -- Missing domain part after @
            "john doe@example.com", -- Space in the email address
            "john.doe@example!com", -- Invalid character (!) in the domain part
            "john.doe@.example.com" -- Domain starts with a dot
          ]

    forM_ invalidEmails $ \invalidEmail -> do
      it "responds with JSON indicating that magic link wasn't sent" $ do
        let signupRequest = SignupRequest invalidEmail

        response <- runPostRequest "/signup" signupRequest app
        assertStatus status200 response
        assertJsonContentType response

        decodedResponse <- decodeJsonResponse response
        decodedResponse
          `shouldBe` SignupFailure (InvalidEmail invalidEmail)
