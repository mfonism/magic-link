module App.Context (AppContext (..), initialize) where

import Infra.RabbitMQ qualified

newtype AppContext = AppContext
  { rabbitMQPool :: Infra.RabbitMQ.Pool
  }

initialize :: IO AppContext
initialize = do
  rabbitMQPool <- Infra.RabbitMQ.newPool
  return
    AppContext {rabbitMQPool}
