-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceClonedPayload (ResourceClonedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Agent
import Xynolog.Internal.Generated.Models.ContentFormat
import Xynolog.Internal.Generated.Models.OneOrMoreAgents
import Xynolog.Internal.Generated.Models.ResourceId

data ResourceClonedPayload = ResourceClonedPayload
  { resourceClonedPayloadContentByteSize :: Maybe Integer,
    resourceClonedPayloadContentChecksum :: Text,
    resourceClonedPayloadCreator :: Maybe Agent,
    resourceClonedPayloadEntityTypes :: Maybe [Text],
    resourceClonedPayloadFormat :: ContentFormat,
    resourceClonedPayloadLanguage :: Maybe Text,
    resourceClonedPayloadName :: Text,
    resourceClonedPayloadParentResourceId :: ResourceId,
    resourceClonedPayloadStorageUri :: Maybe Text,
    resourceClonedPayloadWasAttributedTo :: Maybe OneOrMoreAgents
  }
  deriving (Eq, Show)

instance FromJSON ResourceClonedPayload where parseJSON = checked "ResourceClonedPayload" $ withObject "ResourceClonedPayload" (\fields -> ResourceClonedPayload <$> optional fields "contentByteSize" <*> (fields .: "contentChecksum") <*> optional fields "creator" <*> optional fields "entityTypes" <*> (fields .: "format") <*> optional fields "language" <*> (fields .: "name") <*> (fields .: "parentResourceId") <*> optional fields "storageUri" <*> optional fields "wasAttributedTo")

instance ToJSON ResourceClonedPayload where toJSON value = Object (KM.fromList (concat [optionalPair "contentByteSize" (resourceClonedPayloadContentByteSize value), [("contentChecksum", toJSON (resourceClonedPayloadContentChecksum value))], optionalPair "creator" (resourceClonedPayloadCreator value), optionalPair "entityTypes" (resourceClonedPayloadEntityTypes value), [("format", toJSON (resourceClonedPayloadFormat value))], optionalPair "language" (resourceClonedPayloadLanguage value), [("name", toJSON (resourceClonedPayloadName value))], [("parentResourceId", toJSON (resourceClonedPayloadParentResourceId value))], optionalPair "storageUri" (resourceClonedPayloadStorageUri value), optionalPair "wasAttributedTo" (resourceClonedPayloadWasAttributedTo value)]))
