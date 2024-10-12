module API.Signup.Request (SignupRequest (..)) where

import Data.Aeson qualified
import Data.Text (Text)
import GHC.Generics (Generic)

newtype SignupRequest = SignupRequest
  { email :: Text
  }
  deriving (Generic)

instance Data.Aeson.FromJSON SignupRequest

instance Data.Aeson.ToJSON SignupRequest
