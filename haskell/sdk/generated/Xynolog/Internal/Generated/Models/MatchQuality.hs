-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MatchQuality (MatchQuality (..), matchQualityText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data MatchQuality = MatchQualityNormalized | MatchQualityCaseU2d_insensitive | MatchQualityFuzzy deriving (Eq, Show)

instance FromJSON MatchQuality where parseJSON = checked "MatchQuality" $ \value -> if value == String "normalized" then pure MatchQualityNormalized else if value == String "case-insensitive" then pure MatchQualityCaseU2d_insensitive else if value == String "fuzzy" then pure MatchQualityFuzzy else fail "unknown enumeration member"

instance ToJSON MatchQuality where
  toJSON MatchQualityNormalized = String "normalized"
  toJSON MatchQualityCaseU2d_insensitive = String "case-insensitive"
  toJSON MatchQualityFuzzy = String "fuzzy"

matchQualityText :: MatchQuality -> Text
matchQualityText MatchQualityNormalized = "normalized"
matchQualityText MatchQualityCaseU2d_insensitive = "case-insensitive"
matchQualityText MatchQualityFuzzy = "fuzzy"
