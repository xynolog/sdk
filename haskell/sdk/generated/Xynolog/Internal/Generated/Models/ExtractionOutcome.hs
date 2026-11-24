-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ExtractionOutcome (ExtractionOutcome (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ExtractedText
import Xynolog.Internal.Generated.Models.ExtractionDeclined

data ExtractionOutcome = ExtractionOutcomeExtractedText ExtractedText | ExtractionOutcomeExtractionDeclined ExtractionDeclined deriving (Eq, Show)

instance FromJSON ExtractionOutcome where parseJSON = checked "ExtractionOutcome" $ \value -> (ExtractionOutcomeExtractedText <$> parseJSON value) <|> (ExtractionOutcomeExtractionDeclined <$> parseJSON value)

instance ToJSON ExtractionOutcome where
  toJSON (ExtractionOutcomeExtractedText value) = toJSON value
  toJSON (ExtractionOutcomeExtractionDeclined value) = toJSON value
