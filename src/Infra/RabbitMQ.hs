{-# LANGUAGE OverloadedStrings #-}

module Infra.RabbitMQ (connectToRabbitMQ, disconnectFromRabbitMQ) where

import Network.AMQP

connectToRabbitMQ :: IO (Connection, Channel)
connectToRabbitMQ = do
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  chan <- openChannel conn
  return (conn, chan)

disconnectFromRabbitMQ :: Connection -> IO ()
disconnectFromRabbitMQ conn = closeConnection conn
