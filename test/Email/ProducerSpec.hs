module Email.ProducerSpec where

import App.Context qualified
import Data.Aeson (decode)
import Email.Data (Email (..))
import Email.Producer (enqueueEmail)
import Network.AMQP
import Test.Hspec

testEmailEnqueueing :: Spec
testEmailEnqueueing = do
  appCtx <- runIO App.Context.initialize

  describe "Email Enqueueing" $ do
    it "sends an email to the email queue" $ do
      let email =
            Email
              { to = "magic@link.com",
                subject = "Hey there, user!",
                body = "This is magic link!!!"
              }
      enqueueEmail appCtx email

      chan <- openChannel appCtx.rabbitMQConnection
      gotMsg <- getMsg chan Ack "email_queue"

      case gotMsg of
        Just (msg, envelope) -> do
          let decodedEmail = decode (msgBody msg) :: Maybe Email
          decodedEmail `shouldBe` Just email
          ackEnv envelope
        Nothing -> expectationFailure "No message found in email queue"

      closeChannel chan
