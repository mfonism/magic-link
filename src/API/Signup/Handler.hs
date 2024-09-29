module API.Signup.Handler (signupHandler) where

import API.Signup.Request (SignupRequest (..))
import API.Signup.Response (SignupResponse (..))
import Servant (Handler)

signupHandler :: SignupRequest -> Handler SignupResponse
signupHandler (SignupRequest email) = return $ SignupResponse email True
