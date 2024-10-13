module Email.Producer where

import App.Context (AppContext (..))
import Data.Aeson qualified
import Data.Text qualified
import Email.Data (Email (..))
import Network.AMQP

enqueueEmail :: AppContext -> Email -> IO ()
enqueueEmail appContext email = do
  let conn = appContext.rabbitMQConnection
  chan <- openChannel conn

  _ <- declareQueue chan newQueue {queueName = "email_queue"}
  _ <-
    publishMsg
      chan
      ""
      "email_queue"
      newMsg {msgBody = Data.Aeson.encode email, msgDeliveryMode = Just Persistent}

  closeChannel chan
  putStrLn $ "Email task  queued for: " ++ Data.Text.unpack email.to
