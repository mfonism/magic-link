module Main where

import App (mkApp)
import App.Context qualified as AppContext
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = do
  appCtx <- AppContext.initialize
  putStrLn "Starting server on port 8080"
  run 8080 $ mkApp appCtx
