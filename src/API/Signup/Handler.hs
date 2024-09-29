module API.Signup.Handler where

import API.Signup.Request (SignupRequest (..))
import API.Signup.Response (SignupResponse (..))
import Servant

signupHandler :: SignupRequest -> Handler SignupResponse
signupHandler (SignupRequest email) = return $ SignupResponse email True
