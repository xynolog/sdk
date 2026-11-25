-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ReconciledSpanFuzzyMatch (ReconciledSpanFuzzyMatch (..), ReconciledSpanFuzzyMatchAnchorMethod (..), reconciledSpanFuzzyMatchAnchorMethodText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MatchQuality

data ReconciledSpanFuzzyMatch = ReconciledSpanFuzzyMatch
  { reconciledSpanFuzzyMatchAnchorMethod :: ReconciledSpanFuzzyMatchAnchorMethod,
    reconciledSpanFuzzyMatchStart :: Integer,
    reconciledSpanFuzzyMatchEnd :: Integer,
    reconciledSpanFuzzyMatchExact :: Text,
    reconciledSpanFuzzyMatchPrefix :: Maybe Text,
    reconciledSpanFuzzyMatchSuffix :: Maybe Text,
    reconciledSpanFuzzyMatchMatchQuality :: MatchQuality
  }
  deriving (Eq, Show)

instance FromJSON ReconciledSpanFuzzyMatch where parseJSON = checked "ReconciledSpanFuzzyMatch" $ withObject "ReconciledSpanFuzzyMatch" (\fields -> ReconciledSpanFuzzyMatch <$> (fields .: "anchorMethod") <*> (fields .: "start") <*> (fields .: "end") <*> (fields .: "exact") <*> optional fields "prefix" <*> optional fields "suffix" <*> (fields .: "matchQuality"))

instance ToJSON ReconciledSpanFuzzyMatch where toJSON value = Object (KM.fromList (concat [[("anchorMethod", toJSON (reconciledSpanFuzzyMatchAnchorMethod value))], [("start", toJSON (reconciledSpanFuzzyMatchStart value))], [("end", toJSON (reconciledSpanFuzzyMatchEnd value))], [("exact", toJSON (reconciledSpanFuzzyMatchExact value))], optionalPair "prefix" (reconciledSpanFuzzyMatchPrefix value), optionalPair "suffix" (reconciledSpanFuzzyMatchSuffix value), [("matchQuality", toJSON (reconciledSpanFuzzyMatchMatchQuality value))]]))

data ReconciledSpanFuzzyMatchAnchorMethod = ReconciledSpanFuzzyMatchAnchorMethodFuzzyMatch deriving (Eq, Show)

instance FromJSON ReconciledSpanFuzzyMatchAnchorMethod where parseJSON = checked "ReconciledSpanFuzzyMatchAnchorMethod" $ \value -> if value == String "fuzzy-match" then pure ReconciledSpanFuzzyMatchAnchorMethodFuzzyMatch else fail "unknown enumeration member"

instance ToJSON ReconciledSpanFuzzyMatchAnchorMethod where toJSON ReconciledSpanFuzzyMatchAnchorMethodFuzzyMatch = String "fuzzy-match"

reconciledSpanFuzzyMatchAnchorMethodText :: ReconciledSpanFuzzyMatchAnchorMethod -> Text
reconciledSpanFuzzyMatchAnchorMethodText ReconciledSpanFuzzyMatchAnchorMethodFuzzyMatch = "fuzzy-match"
