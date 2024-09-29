module API.Signup.Response (SignupResponse (..)) where

import Data.Aeson qualified
import GHC.Generics (Generic)

data SignupResponse = SignupResponse
  { email :: String,
    magicLinkSent :: Bool
  }
  deriving (Eq, Show, Generic)

instance Data.Aeson.FromJSON SignupResponse

instance Data.Aeson.ToJSON SignupResponse
