{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module App (app, HelloResponse (..)) where

import API.Signup.Handler (signupHandler)
import API.Signup.Request (SignupRequest)
import API.Signup.Response (SignupResponse)
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics (Generic)
import Servant

newtype HelloResponse = HelloResponse
  { message :: String
  }
  deriving (Show, Eq, Generic)

instance ToJSON HelloResponse

instance FromJSON HelloResponse

type API =
  "hello" :> Get '[JSON] HelloResponse
    :<|> "signup" :> ReqBody '[JSON] SignupRequest :> Post '[JSON] SignupResponse

server :: Server API
server =
  (return $ HelloResponse "Hello, Magic Link!")
    :<|> signupHandler

app :: Application
app = serve (Proxy :: Proxy API) server
