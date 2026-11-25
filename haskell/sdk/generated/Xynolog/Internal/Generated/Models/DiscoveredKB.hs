-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveredKB (DiscoveredKB (..), DiscoveredKBPlacement (..), discoveredKBPlacementText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data DiscoveredKB = DiscoveredKB
  { discoveredKBHost :: Text,
    discoveredKBPort :: Integer,
    discoveredKBPlacement :: DiscoveredKBPlacement,
    discoveredKBRepo :: Maybe Text,
    discoveredKBDid :: Text,
    discoveredKBSiteName :: Maybe Text,
    discoveredKBManagedBy :: Text
  }
  deriving (Eq, Show)

instance FromJSON DiscoveredKB where parseJSON = checked "DiscoveredKB" $ withObject "DiscoveredKB" (\fields -> DiscoveredKB <$> (fields .: "host") <*> (fields .: "port") <*> (fields .: "placement") <*> optional fields "repo" <*> (fields .: "did") <*> optional fields "siteName" <*> (fields .: "managedBy"))

instance ToJSON DiscoveredKB where toJSON value = Object (KM.fromList (concat [[("host", toJSON (discoveredKBHost value))], [("port", toJSON (discoveredKBPort value))], [("placement", toJSON (discoveredKBPlacement value))], optionalPair "repo" (discoveredKBRepo value), [("did", toJSON (discoveredKBDid value))], optionalPair "siteName" (discoveredKBSiteName value), [("managedBy", toJSON (discoveredKBManagedBy value))]]))

data DiscoveredKBPlacement = DiscoveredKBPlacementLocal | DiscoveredKBPlacementCodespace deriving (Eq, Show)

instance FromJSON DiscoveredKBPlacement where parseJSON = checked "DiscoveredKBPlacement" $ \value -> if value == String "local" then pure DiscoveredKBPlacementLocal else if value == String "codespace" then pure DiscoveredKBPlacementCodespace else fail "unknown enumeration member"

instance ToJSON DiscoveredKBPlacement where
  toJSON DiscoveredKBPlacementLocal = String "local"
  toJSON DiscoveredKBPlacementCodespace = String "codespace"

discoveredKBPlacementText :: DiscoveredKBPlacement -> Text
discoveredKBPlacementText DiscoveredKBPlacementLocal = "local"
discoveredKBPlacementText DiscoveredKBPlacementCodespace = "codespace"
