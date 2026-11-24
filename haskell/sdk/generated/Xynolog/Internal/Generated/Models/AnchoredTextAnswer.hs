-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchoredTextAnswer (AnchoredTextAnswer (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnchoredTextAbsent
import Xynolog.Internal.Generated.Models.ExtractedText
import Xynolog.Internal.Generated.Models.ExtractionDeclined

data AnchoredTextAnswer = AnchoredTextAnswerExtractedText ExtractedText | AnchoredTextAnswerExtractionDeclined ExtractionDeclined | AnchoredTextAnswerAnchoredTextAbsent AnchoredTextAbsent deriving (Eq, Show)

instance FromJSON AnchoredTextAnswer where parseJSON = checked "AnchoredTextAnswer" $ \value -> (AnchoredTextAnswerExtractedText <$> parseJSON value) <|> (AnchoredTextAnswerExtractionDeclined <$> parseJSON value) <|> (AnchoredTextAnswerAnchoredTextAbsent <$> parseJSON value)

instance ToJSON AnchoredTextAnswer where
  toJSON (AnchoredTextAnswerExtractedText value) = toJSON value
  toJSON (AnchoredTextAnswerExtractionDeclined value) = toJSON value
  toJSON (AnchoredTextAnswerAnchoredTextAbsent value) = toJSON value
