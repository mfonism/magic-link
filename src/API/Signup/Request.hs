module API.Signup.Request (SignupRequest (..)) where

import Data.Aeson qualified
import GHC.Generics (Generic)
import Data.Text (Text)

newtype SignupRequest = SignupRequest
  { email :: Text
  }
  deriving (Generic)

instance Data.Aeson.FromJSON SignupRequest

instance Data.Aeson.ToJSON SignupRequest
