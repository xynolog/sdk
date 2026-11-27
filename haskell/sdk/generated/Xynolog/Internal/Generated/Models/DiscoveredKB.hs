-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveredKB (DiscoveredKB (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbPlacement

data DiscoveredKB = DiscoveredKB
  { discoveredKBHost :: Text,
    discoveredKBPort :: Integer,
    discoveredKBPlacement :: KbPlacement,
    discoveredKBRepo :: Maybe Text,
    discoveredKBDid :: Text,
    discoveredKBSiteName :: Maybe Text,
    discoveredKBManagedBy :: Text
  }
  deriving (Eq, Show)

instance FromJSON DiscoveredKB where parseJSON = checked "DiscoveredKB" $ withObject "DiscoveredKB" (\fields -> DiscoveredKB <$> (fields .: "host") <*> (fields .: "port") <*> (fields .: "placement") <*> optional fields "repo" <*> (fields .: "did") <*> optional fields "siteName" <*> (fields .: "managedBy"))

instance ToJSON DiscoveredKB where toJSON value = Object (KM.fromList (concat [[("host", toJSON (discoveredKBHost value))], [("port", toJSON (discoveredKBPort value))], [("placement", toJSON (discoveredKBPlacement value))], optionalPair "repo" (discoveredKBRepo value), [("did", toJSON (discoveredKBDid value))], optionalPair "siteName" (discoveredKBSiteName value), [("managedBy", toJSON (discoveredKBManagedBy value))]]))
