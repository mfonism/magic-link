module Email.ProducerSpec where

import App.Context qualified
import Data.Aeson (decode)
import Data.Pool (withResource)
import Email.Data (Email (..))
import Email.Producer (enqueueEmail)
import Infra.RabbitMQ qualified as RabbitMQ
import Network.AMQP
import Test.Hspec
import TestUtils (testAppCtx)

testEmailEnqueueing :: Spec
testEmailEnqueueing = do
  appCtx <- runIO testAppCtx

  it "sends an email to the email queue" $ do
    let email =
          Email
            { to = "magic@link.com",
              subject = "Hey there, user!",
              body = "This is magic link!!!"
            }

    withResource appCtx.rabbitMQPool $ \conn -> do
      sendChan <- openChannel conn
      enqueueEmail sendChan email
      closeChannel sendChan

      readChan <- openChannel conn
      let queueName = RabbitMQ.queueName RabbitMQ.EmailQueue
      gotMsg <- getMsg readChan NoAck queueName

      case gotMsg of
        Just (msg, _) -> do
          decode (msgBody msg) `shouldBe` Just email
        Nothing -> expectationFailure "No message found in email queue"

      closeChannel readChan
