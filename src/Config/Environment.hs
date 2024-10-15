module Config.Environment (Environment (..), loadEnvironment) where

import Configuration.Dotenv qualified as Dotenv
import System.Environment qualified

data Environment
  = Dev
  | Test
  | Prod
  deriving (Eq, Show)

loadEnvironment :: IO Environment
loadEnvironment = do
  Dotenv.loadFile Dotenv.defaultConfig

  envVar <- System.Environment.lookupEnv "ENV"
  return $ case envVar of
    Just "TEST" -> Test
    Just "PROD" -> Prod
    _ -> Dev
