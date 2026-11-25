-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DurabilityEvidence (DurabilityEvidence (..), durabilityEvidenceText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data DurabilityEvidence = DurabilityEvidenceAcknowledged | DurabilityEvidenceProbeConfirmed | DurabilityEvidenceProbeRefused | DurabilityEvidenceProbeUnreachable deriving (Eq, Show)

instance FromJSON DurabilityEvidence where parseJSON = checked "DurabilityEvidence" $ \value -> if value == String "acknowledged" then pure DurabilityEvidenceAcknowledged else if value == String "probe-confirmed" then pure DurabilityEvidenceProbeConfirmed else if value == String "probe-refused" then pure DurabilityEvidenceProbeRefused else if value == String "probe-unreachable" then pure DurabilityEvidenceProbeUnreachable else fail "unknown enumeration member"

instance ToJSON DurabilityEvidence where
  toJSON DurabilityEvidenceAcknowledged = String "acknowledged"
  toJSON DurabilityEvidenceProbeConfirmed = String "probe-confirmed"
  toJSON DurabilityEvidenceProbeRefused = String "probe-refused"
  toJSON DurabilityEvidenceProbeUnreachable = String "probe-unreachable"

durabilityEvidenceText :: DurabilityEvidence -> Text
durabilityEvidenceText DurabilityEvidenceAcknowledged = "acknowledged"
durabilityEvidenceText DurabilityEvidenceProbeConfirmed = "probe-confirmed"
durabilityEvidenceText DurabilityEvidenceProbeRefused = "probe-refused"
durabilityEvidenceText DurabilityEvidenceProbeUnreachable = "probe-unreachable"
