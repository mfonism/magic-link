module App (mkApp) where

import App.Context (AppContext)
import Servant (Application, Proxy (..), serve)
import Server qualified

mkApp :: AppContext -> Application
mkApp appCtx = serve (Proxy :: Proxy Server.API) $ Server.mkServer appCtx
