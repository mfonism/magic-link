{-# LANGUAGE DataKinds #-}

module Server (mkServer, API) where

import API.HealthCheck (HealthCheckResponse, healthCheckHandler)
import API.Signup.Handler (signupHandler)
import API.Signup.Request (SignupRequest)
import API.Signup.Response (SignupResponse)
import App.Context (AppContext)
import Servant

type API =
  "health-check" :> Get '[JSON] HealthCheckResponse
    :<|> "signup" :> ReqBody '[JSON] SignupRequest :> Post '[JSON] SignupResponse

mkServer :: AppContext -> Server API
mkServer appCtx =
  healthCheckHandler
    :<|> signupHandler appCtx
