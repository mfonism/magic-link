module App (app, HelloResponse (..)) where

import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics (Generic)
import Servant
import Server qualified

newtype HelloResponse = HelloResponse
  { message :: String
  }
  deriving (Show, Eq, Generic)

instance ToJSON HelloResponse

instance FromJSON HelloResponse

app :: Application
app = serve (Proxy :: Proxy Server.API) Server.server
