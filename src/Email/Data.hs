module Email.Data (Email (..)) where

import Data.Aeson qualified
import Data.Text (Text)
import GHC.Generics (Generic)

data Email = Email
  { to :: Text,
    subject :: Text,
    body :: Text
  }
  deriving (Eq, Show, Generic)

instance Data.Aeson.ToJSON Email

instance Data.Aeson.FromJSON Email
