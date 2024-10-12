module Main where

import API.HealthCheckSpec qualified
import API.Signup.HandlerSpec qualified
import Email.ProducerSpec qualified
import Test.Hspec

main :: IO ()
main = hspec $ do
  API.HealthCheckSpec.handlerSpec
  API.Signup.HandlerSpec.handlerSpec
  Email.ProducerSpec.testEmailEnqueueing
