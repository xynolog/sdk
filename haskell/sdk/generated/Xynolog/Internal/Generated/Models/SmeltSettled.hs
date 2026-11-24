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
  { smeltSettledContentChecksum :: Text,
    smeltSettledOutcome :: SmeltSettledOutcome,
    smeltSettledReason :: Maybe SmeltSettledReason,
    smeltSettledResourceId :: ResourceId,
    smeltSettledAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON SmeltSettled where parseJSON = checked "SmeltSettled" $ withObject "SmeltSettled" (\fields -> SmeltSettled <$> (fields .: "contentChecksum") <*> (fields .: "outcome") <*> optional fields "reason" <*> (fields .: "resourceId") <*> traverse parseJSON (withoutFields ["contentChecksum", "outcome", "reason", "resourceId"] fields))

instance ToJSON SmeltSettled where toJSON value = Object (KM.fromList (concat [[("contentChecksum", toJSON (smeltSettledContentChecksum value))], [("outcome", toJSON (smeltSettledOutcome value))], optionalPair "reason" (smeltSettledReason value), [("resourceId", toJSON (smeltSettledResourceId value))]]) <> fmap toJSON (withoutFields ["contentChecksum", "outcome", "reason", "resourceId"] (smeltSettledAdditionalProperties value)))

data SmeltSettledOutcome = SmeltSettledOutcomeIndexed | SmeltSettledOutcomeSkipped deriving (Eq, Show)

instance FromJSON SmeltSettledOutcome where parseJSON = checked "SmeltSettledOutcome" $ \value -> if value == String "indexed" then pure SmeltSettledOutcomeIndexed else if value == String "skipped" then pure SmeltSettledOutcomeSkipped else fail "unknown enumeration member"

instance ToJSON SmeltSettledOutcome where
  toJSON SmeltSettledOutcomeIndexed = String "indexed"
  toJSON SmeltSettledOutcomeSkipped = String "skipped"

smeltSettledOutcomeText :: SmeltSettledOutcome -> Text
smeltSettledOutcomeText SmeltSettledOutcomeIndexed = "indexed"
smeltSettledOutcomeText SmeltSettledOutcomeSkipped = "skipped"

data SmeltSettledReason = SmeltSettledReasonNoU2d_extractor | SmeltSettledReasonEmpty | SmeltSettledReasonNoU2d_textU2d_layer | SmeltSettledReasonEncrypted | SmeltSettledReasonCorrupt | SmeltSettledReasonTooU2d_large deriving (Eq, Show)

instance FromJSON SmeltSettledReason where parseJSON = checked "SmeltSettledReason" $ \value -> if value == String "no-extractor" then pure SmeltSettledReasonNoU2d_extractor else if value == String "empty" then pure SmeltSettledReasonEmpty else if value == String "no-text-layer" then pure SmeltSettledReasonNoU2d_textU2d_layer else if value == String "encrypted" then pure SmeltSettledReasonEncrypted else if value == String "corrupt" then pure SmeltSettledReasonCorrupt else if value == String "too-large" then pure SmeltSettledReasonTooU2d_large else fail "unknown enumeration member"

instance ToJSON SmeltSettledReason where
  toJSON SmeltSettledReasonNoU2d_extractor = String "no-extractor"
  toJSON SmeltSettledReasonEmpty = String "empty"
  toJSON SmeltSettledReasonNoU2d_textU2d_layer = String "no-text-layer"
  toJSON SmeltSettledReasonEncrypted = String "encrypted"
  toJSON SmeltSettledReasonCorrupt = String "corrupt"
  toJSON SmeltSettledReasonTooU2d_large = String "too-large"

smeltSettledReasonText :: SmeltSettledReason -> Text
smeltSettledReasonText SmeltSettledReasonNoU2d_extractor = "no-extractor"
smeltSettledReasonText SmeltSettledReasonEmpty = "empty"
smeltSettledReasonText SmeltSettledReasonNoU2d_textU2d_layer = "no-text-layer"
smeltSettledReasonText SmeltSettledReasonEncrypted = "encrypted"
smeltSettledReasonText SmeltSettledReasonCorrupt = "corrupt"
smeltSettledReasonText SmeltSettledReasonTooU2d_large = "too-large"
