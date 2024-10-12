{-# LANGUAGE OverloadedStrings #-}

module Email.ProducerSpec where

import Data.Aeson (decode)
import Email.Data (Email (..))
import Email.Producer (enqueueEmail)
import Infra.RabbitMQ (connectToRabbitMQ, disconnectFromRabbitMQ)
import Network.AMQP
import Test.Hspec

testEmailEnqueueing :: Spec
testEmailEnqueueing = do
  describe "Email Enqueueing" $ do
    it "sends an email to the email queue" $ do
      let email =
            Email
              { to = "magic@link.com",
                subject = "Hey there, user!",
                body = "This is magic link!!!"
              }
      enqueueEmail email

      (conn, chan) <- connectToRabbitMQ
      gotMsg <- getMsg chan Ack "email_queue"

      case gotMsg of
        Just (msg, envelope) -> do
          let decodedEmail = decode (msgBody msg) :: Maybe Email
          decodedEmail `shouldBe` Just email
          ackEnv envelope
        Nothing -> expectationFailure "No message found in email queue"

      disconnectFromRabbitMQ conn
