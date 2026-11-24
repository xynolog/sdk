-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchoredTextEntry (AnchoredTextEntry (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnchoredTextDeclinedEntry
import Xynolog.Internal.Generated.Models.AnchoredTextExtractedEntry

data AnchoredTextEntry = AnchoredTextEntryAnchoredTextExtractedEntry AnchoredTextExtractedEntry | AnchoredTextEntryAnchoredTextDeclinedEntry AnchoredTextDeclinedEntry deriving (Eq, Show)

instance FromJSON AnchoredTextEntry where parseJSON = checked "AnchoredTextEntry" $ \value -> (AnchoredTextEntryAnchoredTextExtractedEntry <$> parseJSON value) <|> (AnchoredTextEntryAnchoredTextDeclinedEntry <$> parseJSON value)

instance ToJSON AnchoredTextEntry where
  toJSON (AnchoredTextEntryAnchoredTextExtractedEntry value) = toJSON value
  toJSON (AnchoredTextEntryAnchoredTextDeclinedEntry value) = toJSON value
