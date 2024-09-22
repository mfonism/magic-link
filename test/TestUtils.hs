module TestUtils (decodeJsonResponse) where

import Data.Aeson qualified
import Data.ByteString.Lazy.Char8 qualified as BL8
import Network.Wai.Test (SResponse, simpleBody)

decodeJsonResponse :: (Data.Aeson.FromJSON a, Show a) => SResponse -> IO a
decodeJsonResponse response = do
  let responseBody = simpleBody response
  case Data.Aeson.decode responseBody of
    Just decodedResponse -> return decodedResponse
    Nothing ->
      fail $
        "Failed to decode response body. Raw response:\n"
          ++ BL8.unpack responseBody
