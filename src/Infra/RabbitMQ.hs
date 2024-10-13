module Infra.RabbitMQ where

import Data.Pool qualified
import Network.AMQP (Connection)
import Network.AMQP qualified

type Pool = Data.Pool.Pool Connection

newPool :: IO Pool
newPool = do
  let create = Network.AMQP.openConnection "127.0.0.1" "/" "guest" "guest"
      destroy = Network.AMQP.closeConnection
      idleTime = 5 * 60
      maxConnections = 10
  Data.Pool.newPool $ Data.Pool.defaultPoolConfig create destroy idleTime maxConnections
