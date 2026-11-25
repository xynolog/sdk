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
  { textualBodyFormat :: Maybe Text,
    textualBodyLanguage :: Maybe Text,
    textualBodyPurpose :: Maybe BodyPurpose,
    textualBodyType :: TextualBodyType,
    textualBodyValue :: Text
  }
  deriving (Eq, Show)

instance FromJSON TextualBody where parseJSON = checked "TextualBody" $ withObject "TextualBody" (\fields -> TextualBody <$> optional fields "format" <*> optional fields "language" <*> optional fields "purpose" <*> (fields .: "type") <*> (fields .: "value"))

instance ToJSON TextualBody where toJSON value = Object (KM.fromList (concat [optionalPair "format" (textualBodyFormat value), optionalPair "language" (textualBodyLanguage value), optionalPair "purpose" (textualBodyPurpose value), [("type", toJSON (textualBodyType value))], [("value", toJSON (textualBodyValue value))]]))

data TextualBodyType = TextualBodyTypeTextualBody deriving (Eq, Show)

instance FromJSON TextualBodyType where parseJSON = checked "TextualBodyType" $ \value -> if value == String "TextualBody" then pure TextualBodyTypeTextualBody else fail "unknown enumeration member"

instance ToJSON TextualBodyType where toJSON TextualBodyTypeTextualBody = String "TextualBody"

textualBodyTypeText :: TextualBodyType -> Text
textualBodyTypeText TextualBodyTypeTextualBody = "TextualBody"
