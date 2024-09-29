module API.HealthCheck (HealthCheckResponse (..), healthCheckHandler) where

import Data.Aeson qualified
import GHC.Generics (Generic)
import Servant (Handler)

newtype HealthCheckResponse = HealthCheckResponse
  { ok :: Bool
  }
  deriving (Eq, Show, Generic)

instance Data.Aeson.FromJSON HealthCheckResponse

instance Data.Aeson.ToJSON HealthCheckResponse

healthCheckHandler :: Handler HealthCheckResponse
healthCheckHandler = return $ HealthCheckResponse True
