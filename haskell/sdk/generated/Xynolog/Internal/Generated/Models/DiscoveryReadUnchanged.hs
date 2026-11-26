-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryReadUnchanged (DiscoveryReadUnchanged (..), DiscoveryReadUnchangedKind (..), discoveryReadUnchangedKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data DiscoveryReadUnchanged = DiscoveryReadUnchanged
  { discoveryReadUnchangedKind :: DiscoveryReadUnchangedKind
  }
  deriving (Eq, Show)

instance FromJSON DiscoveryReadUnchanged where parseJSON = checked "DiscoveryReadUnchanged" $ withObject "DiscoveryReadUnchanged" (\fields -> DiscoveryReadUnchanged <$> (fields .: "kind"))

instance ToJSON DiscoveryReadUnchanged where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (discoveryReadUnchangedKind value))]]))

data DiscoveryReadUnchangedKind = DiscoveryReadUnchangedKindUnchanged deriving (Eq, Show)

instance FromJSON DiscoveryReadUnchangedKind where parseJSON = checked "DiscoveryReadUnchangedKind" $ \value -> if value == String "unchanged" then pure DiscoveryReadUnchangedKindUnchanged else fail "unknown enumeration member"

instance ToJSON DiscoveryReadUnchangedKind where toJSON DiscoveryReadUnchangedKindUnchanged = String "unchanged"

discoveryReadUnchangedKindText :: DiscoveryReadUnchangedKind -> Text
discoveryReadUnchangedKindText DiscoveryReadUnchangedKindUnchanged = "unchanged"
