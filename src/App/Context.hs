module App.Context (AppContext (..), initialize) where

import Network.AMQP (Connection, openConnection)

newtype AppContext = AppContext
  { rabbitMQConnection :: Connection
  }

initialize :: IO AppContext
initialize = do
  connRabbitMQ <- openConnection "127.0.0.1" "/" "guest" "guest"
  return $
    AppContext
      { rabbitMQConnection = connRabbitMQ
      }
