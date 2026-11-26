-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryReadManaged (DiscoveryReadManaged (..), DiscoveryReadManagedKind (..), discoveryReadManagedKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveredKB

data DiscoveryReadManaged = DiscoveryReadManaged
  { discoveryReadManagedKind :: DiscoveryReadManagedKind,
    discoveryReadManagedKbs :: [DiscoveredKB]
  }
  deriving (Eq, Show)

instance FromJSON DiscoveryReadManaged where parseJSON = checked "DiscoveryReadManaged" $ withObject "DiscoveryReadManaged" (\fields -> DiscoveryReadManaged <$> (fields .: "kind") <*> (fields .: "kbs"))

instance ToJSON DiscoveryReadManaged where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (discoveryReadManagedKind value))], [("kbs", toJSON (discoveryReadManagedKbs value))]]))

data DiscoveryReadManagedKind = DiscoveryReadManagedKindManaged deriving (Eq, Show)

instance FromJSON DiscoveryReadManagedKind where parseJSON = checked "DiscoveryReadManagedKind" $ \value -> if value == String "managed" then pure DiscoveryReadManagedKindManaged else fail "unknown enumeration member"

instance ToJSON DiscoveryReadManagedKind where toJSON DiscoveryReadManagedKindManaged = String "managed"

discoveryReadManagedKindText :: DiscoveryReadManagedKind -> Text
discoveryReadManagedKindText DiscoveryReadManagedKindManaged = "managed"
