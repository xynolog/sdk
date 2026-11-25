-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TextualBody (TextualBody (..), TextualBodyType (..), textualBodyTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.BodyPurpose

data TextualBody = TextualBody
  { textualBodyType :: TextualBodyType,
    textualBodyValue :: Text,
    textualBodyPurpose :: Maybe BodyPurpose,
    textualBodyFormat :: Maybe Text,
    textualBodyLanguage :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON TextualBody where parseJSON = checked "TextualBody" $ withObject "TextualBody" (\fields -> TextualBody <$> (fields .: "type") <*> (fields .: "value") <*> optional fields "purpose" <*> optional fields "format" <*> optional fields "language")

instance ToJSON TextualBody where toJSON value = Object (KM.fromList (concat [[("type", toJSON (textualBodyType value))], [("value", toJSON (textualBodyValue value))], optionalPair "purpose" (textualBodyPurpose value), optionalPair "format" (textualBodyFormat value), optionalPair "language" (textualBodyLanguage value)]))

data TextualBodyType = TextualBodyTypeTextualBody deriving (Eq, Show)

instance FromJSON TextualBodyType where parseJSON = checked "TextualBodyType" $ \value -> if value == String "TextualBody" then pure TextualBodyTypeTextualBody else fail "unknown enumeration member"

instance ToJSON TextualBodyType where toJSON TextualBodyTypeTextualBody = String "TextualBody"

textualBodyTypeText :: TextualBodyType -> Text
textualBodyTypeText TextualBodyTypeTextualBody = "TextualBody"
