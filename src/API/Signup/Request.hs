module API.Signup.Request (SignupRequest (..)) where

import Data.Aeson qualified
import GHC.Generics (Generic)

newtype SignupRequest = SignupRequest
  { email :: String
  }
  deriving (Generic)

instance Data.Aeson.FromJSON SignupRequest

instance Data.Aeson.ToJSON SignupRequest
