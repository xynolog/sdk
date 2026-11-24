-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DurabilityEvidence (DurabilityEvidence (..), durabilityEvidenceText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data DurabilityEvidence = DurabilityEvidenceAcknowledged | DurabilityEvidenceProbeU2d_confirmed | DurabilityEvidenceProbeU2d_refused | DurabilityEvidenceProbeU2d_unreachable deriving (Eq, Show)

instance FromJSON DurabilityEvidence where parseJSON = checked "DurabilityEvidence" $ \value -> if value == String "acknowledged" then pure DurabilityEvidenceAcknowledged else if value == String "probe-confirmed" then pure DurabilityEvidenceProbeU2d_confirmed else if value == String "probe-refused" then pure DurabilityEvidenceProbeU2d_refused else if value == String "probe-unreachable" then pure DurabilityEvidenceProbeU2d_unreachable else fail "unknown enumeration member"

instance ToJSON DurabilityEvidence where
  toJSON DurabilityEvidenceAcknowledged = String "acknowledged"
  toJSON DurabilityEvidenceProbeU2d_confirmed = String "probe-confirmed"
  toJSON DurabilityEvidenceProbeU2d_refused = String "probe-refused"
  toJSON DurabilityEvidenceProbeU2d_unreachable = String "probe-unreachable"

durabilityEvidenceText :: DurabilityEvidence -> Text
durabilityEvidenceText DurabilityEvidenceAcknowledged = "acknowledged"
durabilityEvidenceText DurabilityEvidenceProbeU2d_confirmed = "probe-confirmed"
durabilityEvidenceText DurabilityEvidenceProbeU2d_refused = "probe-refused"
durabilityEvidenceText DurabilityEvidenceProbeU2d_unreachable = "probe-unreachable"
