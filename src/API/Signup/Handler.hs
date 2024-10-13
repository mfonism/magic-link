module API.Signup.Handler (signupHandler) where

import API.Signup.Request (SignupRequest (..))
import API.Signup.Response (SignupFailureReason (..), SignupResponse (..))
import App.Context (AppContext)
import App.Context qualified as AppContext
import Control.Monad.IO.Class (MonadIO (liftIO))
import Data.Pool (withResource)
import Data.Text.Encoding qualified as Text
import Email.Data (Email (..))
import Email.Producer qualified
import Network.AMQP
import Servant (Handler)
import Text.Email.Validate (EmailAddress)
import Text.Email.Validate qualified as EmailAddress

signupHandler :: AppContext -> SignupRequest -> Handler SignupResponse
signupHandler appCtx (SignupRequest email) =
  case EmailAddress.validate (Text.encodeUtf8 email) of
    Left _ -> return $ SignupFailure (InvalidEmail email)
    Right validEmail -> do
      liftIO $ withResource appCtx.rabbitMQPool $ \conn -> do
        chan <- openChannel conn
        enqueueSignupEmail chan validEmail
        closeChannel chan

      return $ SignupSuccess validEmail

enqueueSignupEmail :: Channel -> EmailAddress -> IO ()
enqueueSignupEmail chan emailAddress = do
  let email =
        Email
          { to = Text.decodeUtf8 $ EmailAddress.toByteString emailAddress,
            subject = "Signup link",
            body = "Click on this link to signup!"
          }
  Email.Producer.enqueueEmail chan email
