{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module MyLib (app, HelloResponse (..)) where

import Data.Aeson (ToJSON)
import GHC.Generics (Generic)
import Servant

data HelloResponse = HelloResponse {message :: String} deriving (Show, Eq, Generic)

instance ToJSON HelloResponse

type API = "hello" :> Get '[JSON] HelloResponse

server :: Server API
server = return $ HelloResponse "Hello, Magic Link!"

app :: Application
app = serve (Proxy :: Proxy API) server
