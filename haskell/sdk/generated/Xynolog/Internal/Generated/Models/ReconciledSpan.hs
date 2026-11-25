-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ReconciledSpan (ReconciledSpan (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ReconciledSpanContextRecovered
import Xynolog.Internal.Generated.Models.ReconciledSpanFirstOfMany
import Xynolog.Internal.Generated.Models.ReconciledSpanFuzzyMatch
import Xynolog.Internal.Generated.Models.ReconciledSpanUniqueMatch

data ReconciledSpan = ReconciledSpanReconciledSpanUniqueMatch ReconciledSpanUniqueMatch | ReconciledSpanReconciledSpanContextRecovered ReconciledSpanContextRecovered | ReconciledSpanReconciledSpanFirstOfMany ReconciledSpanFirstOfMany | ReconciledSpanReconciledSpanFuzzyMatch ReconciledSpanFuzzyMatch deriving (Eq, Show)

instance FromJSON ReconciledSpan where parseJSON = checked "ReconciledSpan" $ \value -> readMember "ReconciledSpan" [([Signature {signatureKind = ObjectKind, signatureRequired = ["anchorMethod", "start", "end", "exact"], signatureAllowed = Just ["anchorMethod", "start", "end", "exact", "prefix", "suffix"], signatureFixed = [("anchorMethod", [String "unique-match"])], signaturePattern = Nothing, signatureValues = Nothing}], ReconciledSpanReconciledSpanUniqueMatch <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["anchorMethod", "start", "end", "exact"], signatureAllowed = Just ["anchorMethod", "start", "end", "exact", "prefix", "suffix"], signatureFixed = [("anchorMethod", [String "context-recovered"])], signaturePattern = Nothing, signatureValues = Nothing}], ReconciledSpanReconciledSpanContextRecovered <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["anchorMethod", "start", "end", "exact"], signatureAllowed = Just ["anchorMethod", "start", "end", "exact", "prefix", "suffix"], signatureFixed = [("anchorMethod", [String "first-of-many"])], signaturePattern = Nothing, signatureValues = Nothing}], ReconciledSpanReconciledSpanFirstOfMany <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["anchorMethod", "start", "end", "exact", "matchQuality"], signatureAllowed = Just ["anchorMethod", "start", "end", "exact", "prefix", "suffix", "matchQuality"], signatureFixed = [("anchorMethod", [String "fuzzy-match"]), ("matchQuality", [String "normalized", String "case-insensitive", String "fuzzy"])], signaturePattern = Nothing, signatureValues = Nothing}], ReconciledSpanReconciledSpanFuzzyMatch <$> parseJSON value)] value

instance ToJSON ReconciledSpan where
  toJSON (ReconciledSpanReconciledSpanUniqueMatch value) = toJSON value
  toJSON (ReconciledSpanReconciledSpanContextRecovered value) = toJSON value
  toJSON (ReconciledSpanReconciledSpanFirstOfMany value) = toJSON value
  toJSON (ReconciledSpanReconciledSpanFuzzyMatch value) = toJSON value
