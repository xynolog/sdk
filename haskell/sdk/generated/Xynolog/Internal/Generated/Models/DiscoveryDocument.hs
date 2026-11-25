-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryDocument (DiscoveryDocument (..), DiscoveryDocumentVersion (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveredKB

data DiscoveryDocument = DiscoveryDocument
  { discoveryDocumentVersion :: DiscoveryDocumentVersion,
    discoveryDocumentKbs :: [DiscoveredKB]
  }
  deriving (Eq, Show)

instance FromJSON DiscoveryDocument where parseJSON = checked "DiscoveryDocument" $ withObject "DiscoveryDocument" (\fields -> DiscoveryDocument <$> (fields .: "version") <*> (fields .: "kbs"))

instance ToJSON DiscoveryDocument where toJSON value = Object (KM.fromList (concat [[("version", toJSON (discoveryDocumentVersion value))], [("kbs", toJSON (discoveryDocumentKbs value))]]))

data DiscoveryDocumentVersion = DiscoveryDocumentVersion1 deriving (Eq, Show)

instance FromJSON DiscoveryDocumentVersion where parseJSON = checked "DiscoveryDocumentVersion" $ \value -> if value == Number (read "1.0") then pure DiscoveryDocumentVersion1 else fail "unknown enumeration member"

instance ToJSON DiscoveryDocumentVersion where toJSON DiscoveryDocumentVersion1 = Number (read "1.0")
