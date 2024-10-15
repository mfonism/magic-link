module Main where

import App (mkApp)
import App.Context qualified as AppContext
import Config qualified
import Config.Environment (loadEnvironment)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = do
  env <- loadEnvironment
  putStrLn $ "Starting app in " ++ show env ++ " mode"

  config <- Config.loadConfig env

  appCtx <- AppContext.initialize config
  putStrLn "Starting server on port 8080"
  run 8080 $ mkApp appCtx
