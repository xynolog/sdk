-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LocalEndpoint (LocalEndpoint (..), LocalEndpointKind (..), localEndpointKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data LocalEndpoint = LocalEndpoint
  { localEndpointKind :: LocalEndpointKind,
    localEndpointKbId :: Text
  }
  deriving (Eq, Show)

instance FromJSON LocalEndpoint where parseJSON = checked "LocalEndpoint" $ withObject "LocalEndpoint" (\fields -> LocalEndpoint <$> (fields .: "kind") <*> (fields .: "kbId"))

instance ToJSON LocalEndpoint where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (localEndpointKind value))], [("kbId", toJSON (localEndpointKbId value))]]))

data LocalEndpointKind = LocalEndpointKindLocal deriving (Eq, Show)

instance FromJSON LocalEndpointKind where parseJSON = checked "LocalEndpointKind" $ \value -> if value == String "local" then pure LocalEndpointKindLocal else fail "unknown enumeration member"

instance ToJSON LocalEndpointKind where toJSON LocalEndpointKindLocal = String "local"

localEndpointKindText :: LocalEndpointKind -> Text
localEndpointKindText LocalEndpointKindLocal = "local"
