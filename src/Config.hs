module Config (Config (..), loadConfig, RabbitMQConfig (..)) where

import Config.Environment (Environment (..))
import Data.Text (Text)
import Data.Yaml qualified
import GHC.Generics (Generic)

newtype Config = Config
  { rabbitmq :: RabbitMQConfig
  }
  deriving (Show, Generic)

instance Data.Yaml.FromJSON Config

data RabbitMQConfig = RabbitMQConfig
  { host :: String,
    user :: Text,
    password :: Text,
    vhost :: Text
  }
  deriving (Show, Generic)

instance Data.Yaml.FromJSON RabbitMQConfig

loadConfig :: Environment -> IO Config
loadConfig env = do
  let configFile = case env of
        Dev -> "config/dev.yaml"
        Test -> "config/test.yaml"
        Prod -> "config/prod.yaml"
  Data.Yaml.decodeFileThrow configFile
