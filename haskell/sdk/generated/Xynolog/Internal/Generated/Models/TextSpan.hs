-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TextSpan (TextSpan (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data TextSpan = TextSpan
  { textSpanStart :: Integer,
    textSpanEnd :: Integer,
    textSpanExact :: Text,
    textSpanPrefix :: Maybe Text,
    textSpanSuffix :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON TextSpan where parseJSON = checked "TextSpan" $ withObject "TextSpan" (\fields -> TextSpan <$> (fields .: "start") <*> (fields .: "end") <*> (fields .: "exact") <*> optional fields "prefix" <*> optional fields "suffix")

instance ToJSON TextSpan where toJSON value = Object (KM.fromList (concat [[("start", toJSON (textSpanStart value))], [("end", toJSON (textSpanEnd value))], [("exact", toJSON (textSpanExact value))], optionalPair "prefix" (textSpanPrefix value), optionalPair "suffix" (textSpanSuffix value)]))
