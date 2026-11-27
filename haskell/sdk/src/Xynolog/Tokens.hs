{-# LANGUAGE OverloadedStrings #-}

-- | Unverified JWT claim hints. Times and delays are exact epoch seconds.
module Xynolog.Tokens (textClaim, tokenExpiry, isTokenExpired, renewalDelay, refreshDelay) where

import Data.Aeson (Object, Value (..), eitherDecodeStrict')
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString.Base64.URL qualified as Base64
import Data.Scientific (Scientific)
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.Encoding (encodeUtf8)
import Xynolog.Timing qualified as Timing

claims :: Text -> Maybe Object
claims token = case Text.splitOn "." token of
  [_, payload, _] | Text.all urlCharacter payload -> do
    bytes <- either (const Nothing) Just (Base64.decodeUnpadded (encodeUtf8 payload))
    either (const Nothing) Just (eitherDecodeStrict' bytes)
  _ -> Nothing
  where
    urlCharacter character =
      (character >= 'A' && character <= 'Z')
        || (character >= 'a' && character <= 'z')
        || (character >= '0' && character <= '9')
        || character == '-'
        || character == '_'

seconds :: Object -> Key.Key -> Maybe Scientific
seconds values key = case KM.lookup key values of Just (Number value) | value /= 0 -> Just value; _ -> Nothing

textClaim :: Text -> Text -> Maybe Text
textClaim token name = do
  values <- claims token
  case KM.lookup (Key.fromText name) values of { Just (String value) -> Just value; _ -> Nothing }

tokenExpiry :: Text -> Maybe Scientific
tokenExpiry token = claims token >>= (`seconds` "exp")

isTokenExpired :: Text -> Scientific -> Bool
isTokenExpired token now = maybe True (< now) (tokenExpiry token)

renewalDelay :: Scientific -> Scientific -> Scientific
renewalDelay lifetime remaining =
  max
    (remaining - min (fromInteger Timing.refreshBeforeExpMs / 1000) (lifetime / 2))
    (fromInteger Timing.minRefreshDelayMs / 1000)

refreshDelay :: Text -> Scientific -> Maybe Scientific
refreshDelay token now = do
  values <- claims token
  expiry <- seconds values "exp"
  let remaining = max (expiry - now) 0
      lifetime = maybe remaining (\issued -> max (expiry - issued) 0) (seconds values "iat")
  pure (renewalDelay lifetime remaining)
