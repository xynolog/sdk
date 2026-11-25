-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ReconciledSpanContextRecovered (ReconciledSpanContextRecovered (..), ReconciledSpanContextRecoveredAnchorMethod (..), reconciledSpanContextRecoveredAnchorMethodText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ReconciledSpanContextRecovered = ReconciledSpanContextRecovered
  { reconciledSpanContextRecoveredAnchorMethod :: ReconciledSpanContextRecoveredAnchorMethod,
    reconciledSpanContextRecoveredEnd :: Integer,
    reconciledSpanContextRecoveredExact :: Text,
    reconciledSpanContextRecoveredPrefix :: Maybe Text,
    reconciledSpanContextRecoveredStart :: Integer,
    reconciledSpanContextRecoveredSuffix :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ReconciledSpanContextRecovered where parseJSON = checked "ReconciledSpanContextRecovered" $ withObject "ReconciledSpanContextRecovered" (\fields -> ReconciledSpanContextRecovered <$> (fields .: "anchorMethod") <*> (fields .: "end") <*> (fields .: "exact") <*> optional fields "prefix" <*> (fields .: "start") <*> optional fields "suffix")

instance ToJSON ReconciledSpanContextRecovered where toJSON value = Object (KM.fromList (concat [[("anchorMethod", toJSON (reconciledSpanContextRecoveredAnchorMethod value))], [("end", toJSON (reconciledSpanContextRecoveredEnd value))], [("exact", toJSON (reconciledSpanContextRecoveredExact value))], optionalPair "prefix" (reconciledSpanContextRecoveredPrefix value), [("start", toJSON (reconciledSpanContextRecoveredStart value))], optionalPair "suffix" (reconciledSpanContextRecoveredSuffix value)]))

data ReconciledSpanContextRecoveredAnchorMethod = ReconciledSpanContextRecoveredAnchorMethodContextRecovered deriving (Eq, Show)

instance FromJSON ReconciledSpanContextRecoveredAnchorMethod where parseJSON = checked "ReconciledSpanContextRecoveredAnchorMethod" $ \value -> if value == String "context-recovered" then pure ReconciledSpanContextRecoveredAnchorMethodContextRecovered else fail "unknown enumeration member"

instance ToJSON ReconciledSpanContextRecoveredAnchorMethod where toJSON ReconciledSpanContextRecoveredAnchorMethodContextRecovered = String "context-recovered"

reconciledSpanContextRecoveredAnchorMethodText :: ReconciledSpanContextRecoveredAnchorMethod -> Text
reconciledSpanContextRecoveredAnchorMethodText ReconciledSpanContextRecoveredAnchorMethodContextRecovered = "context-recovered"
