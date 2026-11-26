-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryDiff (DiscoveryDiff (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveredKB
import Xynolog.Internal.Generated.Models.DiscoveryState

data DiscoveryDiff = DiscoveryDiff
  { discoveryDiffState :: DiscoveryState,
    discoveryDiffAdded :: [DiscoveredKB],
    discoveryDiffUpdated :: [DiscoveredKB],
    discoveryDiffRemoved :: [DiscoveredKB],
    discoveryDiffDuplicated :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON DiscoveryDiff where parseJSON = checked "DiscoveryDiff" $ withObject "DiscoveryDiff" (\fields -> DiscoveryDiff <$> (fields .: "state") <*> (fields .: "added") <*> (fields .: "updated") <*> (fields .: "removed") <*> (fields .: "duplicated"))

instance ToJSON DiscoveryDiff where toJSON value = Object (KM.fromList (concat [[("state", toJSON (discoveryDiffState value))], [("added", toJSON (discoveryDiffAdded value))], [("updated", toJSON (discoveryDiffUpdated value))], [("removed", toJSON (discoveryDiffRemoved value))], [("duplicated", toJSON (discoveryDiffDuplicated value))]]))
