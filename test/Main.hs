module Main where

import API.HealthCheckSpec qualified
import API.Signup.HandlerSpec qualified
import App.Context qualified
import Data.Pool (withResource)
import Email.ProducerSpec qualified
import Test.Hspec
import TestUtils (purgeAllQueues, testAppCtx)

main :: IO ()
main = do
  appCtx <- testAppCtx
  withResource appCtx.rabbitMQPool $ \conn -> do
    hspec
      $ before
        (purgeAllQueues conn)
      $ afterAll_
        (purgeAllQueues conn)
        allSpecs

allSpecs :: Spec
allSpecs = do
  API.HealthCheckSpec.handlerSpec
  API.Signup.HandlerSpec.handlerSpec
  Email.ProducerSpec.testEmailEnqueueing
