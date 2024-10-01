module Main where

import App (app)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = do
  putStrLn "Starting server on port 8080"
  run 8080 app
