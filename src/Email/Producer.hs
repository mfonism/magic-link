{-# LANGUAGE OverloadedStrings #-}

module Email.Producer where

import Data.Aeson qualified
import Data.Text qualified
import Email.Data (Email (..))
import Infra.RabbitMQ (connectToRabbitMQ, disconnectFromRabbitMQ)
import Network.AMQP

enqueueEmail :: Email -> IO ()
enqueueEmail email = do
  (conn, chan) <- connectToRabbitMQ

  _ <- declareQueue chan newQueue {queueName = "email_queue"}
  _ <-
    publishMsg
      chan
      ""
      "email_queue"
      newMsg {msgBody = Data.Aeson.encode email, msgDeliveryMode = Just Persistent}

  disconnectFromRabbitMQ conn
  putStrLn $ "Email task  queued for: " ++ Data.Text.unpack email.to
