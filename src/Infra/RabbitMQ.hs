module Infra.RabbitMQ where

import Config qualified
import Data.Char qualified as Char
import Data.Pool qualified
import Data.Text (Text)
import Data.Text qualified as Text
import Network.AMQP (Connection)
import Network.AMQP qualified

type Pool = Data.Pool.Pool Connection

data Queue = EmailQueue
  deriving (Eq, Ord, Show, Enum, Bounded)

queueName :: Queue -> Text
queueName = Text.pack . toSnakeCase . show
  where
    toSnakeCase :: String -> String
    toSnakeCase paschalCasedString =
      concatMap
        ( \(idx :: Integer, char) ->
            if idx == 0
              then [Char.toLower char]
              else
                if Char.isUpper char
                  then ['_', Char.toLower char]
                  else [char]
        )
        $ zip [0 ..] paschalCasedString

newPool :: Config.RabbitMQConfig -> IO Pool
newPool config = do
  let create = Network.AMQP.openConnection config.host config.vhost config.user config.password
      destroy = Network.AMQP.closeConnection
      idleTime = 5 * 60
      maxConnections = 10
  Data.Pool.newPool $ Data.Pool.defaultPoolConfig create destroy idleTime maxConnections
