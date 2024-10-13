module Email.Producer where

import Data.Aeson qualified
import Data.Text qualified
import Email.Data (Email (..))
import Network.AMQP

enqueueEmail :: Channel -> Email -> IO ()
enqueueEmail chan email = do
  _ <- declareQueue chan newQueue {queueName = "email_queue"}
  _ <-
    publishMsg
      chan
      ""
      "email_queue"
      newMsg {msgBody = Data.Aeson.encode email, msgDeliveryMode = Just Persistent}

  putStrLn $ "Email task  queued for: " ++ Data.Text.unpack email.to
