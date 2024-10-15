module Infra.RabbitMQ where

import Config qualified
import Data.Pool qualified
import Network.AMQP (Connection)
import Network.AMQP qualified

type Pool = Data.Pool.Pool Connection

newPool :: Config.RabbitMQConfig -> IO Pool
newPool config = do
  let create = Network.AMQP.openConnection config.host config.vhost config.user config.password
      destroy = Network.AMQP.closeConnection
      idleTime = 5 * 60
      maxConnections = 10
  Data.Pool.newPool $ Data.Pool.defaultPoolConfig create destroy idleTime maxConnections
