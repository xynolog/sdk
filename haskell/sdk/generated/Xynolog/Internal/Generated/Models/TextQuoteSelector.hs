-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TextQuoteSelector (TextQuoteSelector (..), TextQuoteSelectorType (..), textQuoteSelectorTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data TextQuoteSelector = TextQuoteSelector
  { textQuoteSelectorExact :: Text,
    textQuoteSelectorPrefix :: Maybe Text,
    textQuoteSelectorSuffix :: Maybe Text,
    textQuoteSelectorType :: TextQuoteSelectorType,
    textQuoteSelectorAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON TextQuoteSelector where parseJSON = checked "TextQuoteSelector" $ withObject "TextQuoteSelector" (\fields -> TextQuoteSelector <$> (fields .: "exact") <*> optional fields "prefix" <*> optional fields "suffix" <*> (fields .: "type") <*> traverse parseJSON (withoutFields ["exact", "prefix", "suffix", "type"] fields))

instance ToJSON TextQuoteSelector where toJSON value = Object (KM.fromList (concat [[("exact", toJSON (textQuoteSelectorExact value))], optionalPair "prefix" (textQuoteSelectorPrefix value), optionalPair "suffix" (textQuoteSelectorSuffix value), [("type", toJSON (textQuoteSelectorType value))]]) <> fmap toJSON (withoutFields ["exact", "prefix", "suffix", "type"] (textQuoteSelectorAdditionalProperties value)))

data TextQuoteSelectorType = TextQuoteSelectorTypeTextQuoteSelector deriving (Eq, Show)

instance FromJSON TextQuoteSelectorType where parseJSON = checked "TextQuoteSelectorType" $ \value -> if value == String "TextQuoteSelector" then pure TextQuoteSelectorTypeTextQuoteSelector else fail "unknown enumeration member"

instance ToJSON TextQuoteSelectorType where toJSON TextQuoteSelectorTypeTextQuoteSelector = String "TextQuoteSelector"

textQuoteSelectorTypeText :: TextQuoteSelectorType -> Text
textQuoteSelectorTypeText TextQuoteSelectorTypeTextQuoteSelector = "TextQuoteSelector"
