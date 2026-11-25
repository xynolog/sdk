-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveredKB (DiscoveredKB (..), DiscoveredKBPlacement (..), discoveredKBPlacementText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data DiscoveredKB = DiscoveredKB
  { discoveredKBDid :: Text,
    discoveredKBHost :: Text,
    discoveredKBManagedBy :: Text,
    discoveredKBPlacement :: DiscoveredKBPlacement,
    discoveredKBPort :: Integer,
    discoveredKBRepo :: Maybe Text,
    discoveredKBSiteName :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON DiscoveredKB where parseJSON = checked "DiscoveredKB" $ withObject "DiscoveredKB" (\fields -> DiscoveredKB <$> (fields .: "did") <*> (fields .: "host") <*> (fields .: "managedBy") <*> (fields .: "placement") <*> (fields .: "port") <*> optional fields "repo" <*> optional fields "siteName")

instance ToJSON DiscoveredKB where toJSON value = Object (KM.fromList (concat [[("did", toJSON (discoveredKBDid value))], [("host", toJSON (discoveredKBHost value))], [("managedBy", toJSON (discoveredKBManagedBy value))], [("placement", toJSON (discoveredKBPlacement value))], [("port", toJSON (discoveredKBPort value))], optionalPair "repo" (discoveredKBRepo value), optionalPair "siteName" (discoveredKBSiteName value)]))

data DiscoveredKBPlacement = DiscoveredKBPlacementLocal | DiscoveredKBPlacementCodespace deriving (Eq, Show)

instance FromJSON DiscoveredKBPlacement where parseJSON = checked "DiscoveredKBPlacement" $ \value -> if value == String "local" then pure DiscoveredKBPlacementLocal else if value == String "codespace" then pure DiscoveredKBPlacementCodespace else fail "unknown enumeration member"

instance ToJSON DiscoveredKBPlacement where
  toJSON DiscoveredKBPlacementLocal = String "local"
  toJSON DiscoveredKBPlacementCodespace = String "codespace"

discoveredKBPlacementText :: DiscoveredKBPlacement -> Text
discoveredKBPlacementText DiscoveredKBPlacementLocal = "local"
discoveredKBPlacementText DiscoveredKBPlacementCodespace = "codespace"
