-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryAbsent (DiscoveryAbsent (..), DiscoveryAbsentKind (..), discoveryAbsentKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Discovery.Reasons (DiscoveryAbsentCode (..))
import Xynolog.Internal.Codec

data DiscoveryAbsent = DiscoveryAbsent
  { discoveryAbsentKind :: DiscoveryAbsentKind,
    discoveryAbsentReason :: DiscoveryAbsentCode,
    discoveryAbsentDiagnostic :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON DiscoveryAbsent where parseJSON = checked "DiscoveryAbsent" $ withObject "DiscoveryAbsent" (\fields -> DiscoveryAbsent <$> (fields .: "kind") <*> (fields .: "reason") <*> optional fields "diagnostic")

instance ToJSON DiscoveryAbsent where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (discoveryAbsentKind value))], [("reason", toJSON (discoveryAbsentReason value))], optionalPair "diagnostic" (discoveryAbsentDiagnostic value)]))

data DiscoveryAbsentKind = DiscoveryAbsentKindAbsent deriving (Eq, Show)

instance FromJSON DiscoveryAbsentKind where parseJSON = checked "DiscoveryAbsentKind" $ \value -> if value == String "absent" then pure DiscoveryAbsentKindAbsent else fail "unknown enumeration member"

instance ToJSON DiscoveryAbsentKind where toJSON DiscoveryAbsentKindAbsent = String "absent"

discoveryAbsentKindText :: DiscoveryAbsentKind -> Text
discoveryAbsentKindText DiscoveryAbsentKindAbsent = "absent"
