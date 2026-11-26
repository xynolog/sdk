-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryUnchanged (DiscoveryUnchanged (..), DiscoveryUnchangedKind (..), discoveryUnchangedKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data DiscoveryUnchanged = DiscoveryUnchanged
  { discoveryUnchangedKind :: DiscoveryUnchangedKind
  }
  deriving (Eq, Show)

instance FromJSON DiscoveryUnchanged where parseJSON = checked "DiscoveryUnchanged" $ withObject "DiscoveryUnchanged" (\fields -> DiscoveryUnchanged <$> (fields .: "kind"))

instance ToJSON DiscoveryUnchanged where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (discoveryUnchangedKind value))]]))

data DiscoveryUnchangedKind = DiscoveryUnchangedKindUnchanged deriving (Eq, Show)

instance FromJSON DiscoveryUnchangedKind where parseJSON = checked "DiscoveryUnchangedKind" $ \value -> if value == String "unchanged" then pure DiscoveryUnchangedKindUnchanged else fail "unknown enumeration member"

instance ToJSON DiscoveryUnchangedKind where toJSON DiscoveryUnchangedKindUnchanged = String "unchanged"

discoveryUnchangedKindText :: DiscoveryUnchangedKind -> Text
discoveryUnchangedKindText DiscoveryUnchangedKindUnchanged = "unchanged"
