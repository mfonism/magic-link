module App (mkApp, HelloResponse (..)) where

import App.Context (AppContext)
import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)
import Servant
import Server qualified

newtype HelloResponse = HelloResponse
  { message :: Text
  }
  deriving (Show, Eq, Generic)

instance ToJSON HelloResponse

instance FromJSON HelloResponse

mkApp :: AppContext -> Application
mkApp appCtx = serve (Proxy :: Proxy Server.API) $ Server.mkServer appCtx
