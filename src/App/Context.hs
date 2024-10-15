module App.Context (AppContext (..), initialize) where

import Config (Config (..))
import Infra.RabbitMQ qualified

newtype AppContext = AppContext
  { rabbitMQPool :: Infra.RabbitMQ.Pool
  }

initialize :: Config -> IO AppContext
initialize config = do
  rabbitMQPool <- Infra.RabbitMQ.newPool config.rabbitmq
  return
    AppContext {rabbitMQPool}
