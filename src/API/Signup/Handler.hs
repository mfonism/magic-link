module API.Signup.Handler (signupHandler) where

import API.Signup.Request (SignupRequest (..))
import API.Signup.Response (SignupFailureReason (..), SignupResponse (..))
import Servant (Handler)
import Text.Email.Validate qualified
import Data.Text.Encoding qualified as Text 

signupHandler :: SignupRequest -> Handler SignupResponse
signupHandler (SignupRequest email) =
  return $ case Text.Email.Validate.validate (Text.encodeUtf8 email) of
    Left _ -> SignupFailure (InvalidEmail email)
    Right validEmail -> SignupSuccess validEmail
