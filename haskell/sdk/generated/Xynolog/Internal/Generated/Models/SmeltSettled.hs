-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SmeltSettled (SmeltSettled (..), SmeltSettledOutcome (..), smeltSettledOutcomeText, SmeltSettledReason (..), smeltSettledReasonText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data SmeltSettled = SmeltSettled
  { smeltSettledResourceId :: ResourceId,
    smeltSettledContentChecksum :: Text,
    smeltSettledOutcome :: SmeltSettledOutcome,
    smeltSettledReason :: Maybe SmeltSettledReason
  }
  deriving (Eq, Show)

instance FromJSON SmeltSettled where parseJSON = checked "SmeltSettled" $ withObject "SmeltSettled" (\fields -> SmeltSettled <$> (fields .: "resourceId") <*> (fields .: "contentChecksum") <*> (fields .: "outcome") <*> optional fields "reason")

instance ToJSON SmeltSettled where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (smeltSettledResourceId value))], [("contentChecksum", toJSON (smeltSettledContentChecksum value))], [("outcome", toJSON (smeltSettledOutcome value))], optionalPair "reason" (smeltSettledReason value)]))

data SmeltSettledOutcome = SmeltSettledOutcomeIndexed | SmeltSettledOutcomeSkipped deriving (Eq, Show)

instance FromJSON SmeltSettledOutcome where parseJSON = checked "SmeltSettledOutcome" $ \value -> if value == String "indexed" then pure SmeltSettledOutcomeIndexed else if value == String "skipped" then pure SmeltSettledOutcomeSkipped else fail "unknown enumeration member"

instance ToJSON SmeltSettledOutcome where
  toJSON SmeltSettledOutcomeIndexed = String "indexed"
  toJSON SmeltSettledOutcomeSkipped = String "skipped"

smeltSettledOutcomeText :: SmeltSettledOutcome -> Text
smeltSettledOutcomeText SmeltSettledOutcomeIndexed = "indexed"
smeltSettledOutcomeText SmeltSettledOutcomeSkipped = "skipped"

data SmeltSettledReason = SmeltSettledReasonNoExtractor | SmeltSettledReasonEmpty | SmeltSettledReasonNoTextLayer | SmeltSettledReasonEncrypted | SmeltSettledReasonCorrupt | SmeltSettledReasonTooLarge deriving (Eq, Show)

instance FromJSON SmeltSettledReason where parseJSON = checked "SmeltSettledReason" $ \value -> if value == String "no-extractor" then pure SmeltSettledReasonNoExtractor else if value == String "empty" then pure SmeltSettledReasonEmpty else if value == String "no-text-layer" then pure SmeltSettledReasonNoTextLayer else if value == String "encrypted" then pure SmeltSettledReasonEncrypted else if value == String "corrupt" then pure SmeltSettledReasonCorrupt else if value == String "too-large" then pure SmeltSettledReasonTooLarge else fail "unknown enumeration member"

instance ToJSON SmeltSettledReason where
  toJSON SmeltSettledReasonNoExtractor = String "no-extractor"
  toJSON SmeltSettledReasonEmpty = String "empty"
  toJSON SmeltSettledReasonNoTextLayer = String "no-text-layer"
  toJSON SmeltSettledReasonEncrypted = String "encrypted"
  toJSON SmeltSettledReasonCorrupt = String "corrupt"
  toJSON SmeltSettledReasonTooLarge = String "too-large"

smeltSettledReasonText :: SmeltSettledReason -> Text
smeltSettledReasonText SmeltSettledReasonNoExtractor = "no-extractor"
smeltSettledReasonText SmeltSettledReasonEmpty = "empty"
smeltSettledReasonText SmeltSettledReasonNoTextLayer = "no-text-layer"
smeltSettledReasonText SmeltSettledReasonEncrypted = "encrypted"
smeltSettledReasonText SmeltSettledReasonCorrupt = "corrupt"
smeltSettledReasonText SmeltSettledReasonTooLarge = "too-large"
