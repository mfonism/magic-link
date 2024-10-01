module API.Signup.Handler (signupHandler) where

import API.Signup.Request (SignupRequest (..))
import API.Signup.Response (SignupResponse (..))
import Data.ByteString.Char8 as B8
import Servant (Handler)
import Text.Email.Validate qualified

signupHandler :: SignupRequest -> Handler SignupResponse
signupHandler (SignupRequest email) =
  return $ case Text.Email.Validate.validate (B8.pack email) of
    Left _ -> SignupResponse email False
    Right _ -> SignupResponse email True
