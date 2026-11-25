{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Codec
  ( base64Bytes,
    base64Value,
    checked,
    optional,
    optionalPair,
    withoutFields,
  )
where

import Data.Aeson (FromJSON (..), Object, ToJSON (..), Value (..), withText)
import Data.Aeson.Key (Key)
import Data.Aeson.KeyMap qualified as KM
import Data.Aeson.Types (Parser)
import Data.ByteString (ByteString)
import Data.ByteString.Base64 qualified as Base64
import Data.Text (Text)
import Data.Text.Encoding (decodeLatin1, encodeUtf8)
import Xynolog.Internal.Generated.Schemas (schemas)
import Xynolog.Internal.Schema (validateNamed)

-- | Bytes as JSON writes them: the base64 of what they hold, in a string.
-- Protocol sends bytes as a part of a form, never as JSON; this is what a
-- model that holds them is written and read as.
base64Bytes :: Value -> Parser ByteString
base64Bytes = withText "bytes" (either fail pure . Base64.decode . encodeUtf8)

base64Value :: ByteString -> Value
base64Value = String . decodeLatin1 . Base64.encode

checked :: Text -> (Value -> Parser value) -> Value -> Parser value
checked name parser value = either fail pure (validateNamed schemas name value) >> parser value

optional :: (FromJSON value) => Object -> Key -> Parser (Maybe value)
optional fields key = traverse parseJSON (KM.lookup key fields)

optionalPair :: (ToJSON value) => Key -> Maybe value -> [(Key, Value)]
optionalPair key = maybe [] (\value -> [(key, toJSON value)])

withoutFields :: [Key] -> KM.KeyMap value -> KM.KeyMap value
withoutFields names = KM.filterWithKey (\key _ -> key `notElem` names)
