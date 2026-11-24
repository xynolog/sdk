-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ReconciledSpan (ReconciledSpan (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ReconciledSpanContextRecovered
import Xynolog.Internal.Generated.Models.ReconciledSpanFirstOfMany
import Xynolog.Internal.Generated.Models.ReconciledSpanFuzzyMatch
import Xynolog.Internal.Generated.Models.ReconciledSpanUniqueMatch

data ReconciledSpan = ReconciledSpanReconciledSpanUniqueMatch ReconciledSpanUniqueMatch | ReconciledSpanReconciledSpanContextRecovered ReconciledSpanContextRecovered | ReconciledSpanReconciledSpanFirstOfMany ReconciledSpanFirstOfMany | ReconciledSpanReconciledSpanFuzzyMatch ReconciledSpanFuzzyMatch deriving (Eq, Show)

instance FromJSON ReconciledSpan where parseJSON = checked "ReconciledSpan" $ \value -> (ReconciledSpanReconciledSpanUniqueMatch <$> parseJSON value) <|> (ReconciledSpanReconciledSpanContextRecovered <$> parseJSON value) <|> (ReconciledSpanReconciledSpanFirstOfMany <$> parseJSON value) <|> (ReconciledSpanReconciledSpanFuzzyMatch <$> parseJSON value)

instance ToJSON ReconciledSpan where
  toJSON (ReconciledSpanReconciledSpanUniqueMatch value) = toJSON value
  toJSON (ReconciledSpanReconciledSpanContextRecovered value) = toJSON value
  toJSON (ReconciledSpanReconciledSpanFirstOfMany value) = toJSON value
  toJSON (ReconciledSpanReconciledSpanFuzzyMatch value) = toJSON value
