module Email.Producer where

import Data.Aeson qualified
import Data.Text qualified
import Email.Data (Email (..))
import Infra.RabbitMQ qualified as RabbitMQ
import Network.AMQP

enqueueEmail :: Channel -> Email -> IO ()
enqueueEmail chan email = do
  let queueName = RabbitMQ.queueName RabbitMQ.EmailQueue
  _ <- declareQueue chan newQueue {queueName}
  _ <-
    publishMsg
      chan
      ""
      queueName
      newMsg {msgBody = Data.Aeson.encode email, msgDeliveryMode = Just Persistent}

  putStrLn $ "Email task  queued for: " ++ Data.Text.unpack email.to
