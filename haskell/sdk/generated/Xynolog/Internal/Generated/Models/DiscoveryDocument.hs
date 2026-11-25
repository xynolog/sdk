-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryDocument (DiscoveryDocument (..), DiscoveryDocumentVersion (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveredKB

data DiscoveryDocument = DiscoveryDocument
  { discoveryDocumentKbs :: [DiscoveredKB],
    discoveryDocumentVersion :: DiscoveryDocumentVersion,
    discoveryDocumentAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON DiscoveryDocument where parseJSON = checked "DiscoveryDocument" $ withObject "DiscoveryDocument" (\fields -> DiscoveryDocument <$> (fields .: "kbs") <*> (fields .: "version") <*> traverse parseJSON (withoutFields ["kbs", "version"] fields))

instance ToJSON DiscoveryDocument where toJSON value = Object (KM.fromList (concat [[("kbs", toJSON (discoveryDocumentKbs value))], [("version", toJSON (discoveryDocumentVersion value))]]) <> fmap toJSON (withoutFields ["kbs", "version"] (discoveryDocumentAdditionalProperties value)))

data DiscoveryDocumentVersion = DiscoveryDocumentVersion1 deriving (Eq, Show)

instance FromJSON DiscoveryDocumentVersion where parseJSON = checked "DiscoveryDocumentVersion" $ \value -> if value == Number (read "1.0") then pure DiscoveryDocumentVersion1 else fail "unknown enumeration member"

instance ToJSON DiscoveryDocumentVersion where toJSON DiscoveryDocumentVersion1 = Number (read "1.0")
