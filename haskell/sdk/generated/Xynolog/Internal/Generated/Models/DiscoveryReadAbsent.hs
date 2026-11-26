-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryReadAbsent (DiscoveryReadAbsent (..), DiscoveryReadAbsentKind (..), discoveryReadAbsentKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data DiscoveryReadAbsent = DiscoveryReadAbsent
  { discoveryReadAbsentKind :: DiscoveryReadAbsentKind,
    discoveryReadAbsentReason :: Text,
    discoveryReadAbsentDiagnostic :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON DiscoveryReadAbsent where parseJSON = checked "DiscoveryReadAbsent" $ withObject "DiscoveryReadAbsent" (\fields -> DiscoveryReadAbsent <$> (fields .: "kind") <*> (fields .: "reason") <*> optional fields "diagnostic")

instance ToJSON DiscoveryReadAbsent where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (discoveryReadAbsentKind value))], [("reason", toJSON (discoveryReadAbsentReason value))], optionalPair "diagnostic" (discoveryReadAbsentDiagnostic value)]))

data DiscoveryReadAbsentKind = DiscoveryReadAbsentKindAbsent deriving (Eq, Show)

instance FromJSON DiscoveryReadAbsentKind where parseJSON = checked "DiscoveryReadAbsentKind" $ \value -> if value == String "absent" then pure DiscoveryReadAbsentKindAbsent else fail "unknown enumeration member"

instance ToJSON DiscoveryReadAbsentKind where toJSON DiscoveryReadAbsentKindAbsent = String "absent"

discoveryReadAbsentKindText :: DiscoveryReadAbsentKind -> Text
discoveryReadAbsentKindText DiscoveryReadAbsentKindAbsent = "absent"
