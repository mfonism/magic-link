module Email.ProducerSpec where

import App.Context qualified
import Data.Aeson (decode)
import Data.Pool (withResource)
import Email.Data (Email (..))
import Email.Producer (enqueueEmail)
import Network.AMQP
import Test.Hspec

testEmailEnqueueing :: Spec
testEmailEnqueueing = do
  appCtx <- runIO App.Context.initialize

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
      gotMsg <- getMsg readChan Ack "email_queue"

      case gotMsg of
        Just (msg, envelope) -> do
          ackEnv envelope
          _ <- purgeQueue readChan "email_queue"

          decode (msgBody msg) `shouldBe` Just email
        Nothing -> expectationFailure "No message found in email queue"

      closeChannel readChan
