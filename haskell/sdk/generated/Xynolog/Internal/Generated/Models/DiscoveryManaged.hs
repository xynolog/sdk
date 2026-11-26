-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryManaged (DiscoveryManaged (..), DiscoveryManagedKind (..), discoveryManagedKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveredKB

data DiscoveryManaged = DiscoveryManaged
  { discoveryManagedKind :: DiscoveryManagedKind,
    discoveryManagedKbs :: [DiscoveredKB]
  }
  deriving (Eq, Show)

instance FromJSON DiscoveryManaged where parseJSON = checked "DiscoveryManaged" $ withObject "DiscoveryManaged" (\fields -> DiscoveryManaged <$> (fields .: "kind") <*> (fields .: "kbs"))

instance ToJSON DiscoveryManaged where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (discoveryManagedKind value))], [("kbs", toJSON (discoveryManagedKbs value))]]))

data DiscoveryManagedKind = DiscoveryManagedKindManaged deriving (Eq, Show)

instance FromJSON DiscoveryManagedKind where parseJSON = checked "DiscoveryManagedKind" $ \value -> if value == String "managed" then pure DiscoveryManagedKindManaged else fail "unknown enumeration member"

instance ToJSON DiscoveryManagedKind where toJSON DiscoveryManagedKindManaged = String "managed"

discoveryManagedKindText :: DiscoveryManagedKind -> Text
discoveryManagedKindText DiscoveryManagedKindManaged = "managed"
