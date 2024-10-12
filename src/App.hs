module App (app, HelloResponse (..)) where

import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics (Generic)
import Servant
import Server qualified
import Data.Text (Text)

newtype HelloResponse = HelloResponse
  { message :: Text
  }
  deriving (Show, Eq, Generic)

instance ToJSON HelloResponse

instance FromJSON HelloResponse

app :: Application
app = serve (Proxy :: Proxy Server.API) Server.server
