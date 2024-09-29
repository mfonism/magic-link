{-# LANGUAGE DataKinds #-}

module Server (server, API) where

import API.HealthCheck (HealthCheckResponse, healthCheckHandler)
import API.Signup.Handler (signupHandler)
import API.Signup.Request (SignupRequest)
import API.Signup.Response (SignupResponse)
import Servant

type API =
  "health-check" :> Get '[JSON] HealthCheckResponse
    :<|> "signup" :> ReqBody '[JSON] SignupRequest :> Post '[JSON] SignupResponse

server :: Server API
server =
  healthCheckHandler
    :<|> signupHandler
