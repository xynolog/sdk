-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryDiff (DiscoveryDiff (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveredKB

data DiscoveryDiff = DiscoveryDiff
  { discoveryDiffAdded :: [DiscoveredKB],
    discoveryDiffUpdated :: [DiscoveredKB],
    discoveryDiffRemoved :: [DiscoveredKB]
  }
  deriving (Eq, Show)

instance FromJSON DiscoveryDiff where parseJSON = checked "DiscoveryDiff" $ withObject "DiscoveryDiff" (\fields -> DiscoveryDiff <$> (fields .: "added") <*> (fields .: "updated") <*> (fields .: "removed"))

instance ToJSON DiscoveryDiff where toJSON value = Object (KM.fromList (concat [[("added", toJSON (discoveryDiffAdded value))], [("updated", toJSON (discoveryDiffUpdated value))], [("removed", toJSON (discoveryDiffRemoved value))]]))
