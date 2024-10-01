{-# OPTIONS_GHC -fno-warn-orphans #-}

module API.Signup.Response (SignupResponse (..), SignupFailureReason (..)) where

import Data.Aeson qualified
import Data.Aeson.Types (Parser)
import Data.Text.Encoding (decodeUtf8With, encodeUtf8)
import Data.Text.Encoding.Error (lenientDecode)
import GHC.Generics (Generic)
import Text.Email.Validate qualified as EmailValidate

data SignupResponse
  = SignupSuccess EmailValidate.EmailAddress
  | SignupFailure SignupFailureReason
  deriving (Eq, Show, Generic)

instance Data.Aeson.FromJSON SignupResponse

instance Data.Aeson.ToJSON SignupResponse

data SignupFailureReason = InvalidEmail String
  deriving (Eq, Show, Generic)

instance Data.Aeson.FromJSON SignupFailureReason

instance Data.Aeson.ToJSON SignupFailureReason

-- Orphan instances for Email Address

instance Data.Aeson.FromJSON EmailValidate.EmailAddress where
  parseJSON :: Data.Aeson.Value -> Parser EmailValidate.EmailAddress
  parseJSON = Data.Aeson.withText "EmailAddress" $ \t ->
    case EmailValidate.validate $ encodeUtf8 t of
      Left err -> fail $ "Failed to parse email address: " <> err
      Right email -> return email

instance Data.Aeson.ToJSON EmailValidate.EmailAddress where
  toJSON :: EmailValidate.EmailAddress -> Data.Aeson.Value
  toJSON = Data.Aeson.String . decodeUtf8With lenientDecode . EmailValidate.toByteString
