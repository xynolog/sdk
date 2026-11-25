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
  { resourceClonedPayloadName :: Text,
    resourceClonedPayloadFormat :: ContentFormat,
    resourceClonedPayloadContentChecksum :: Text,
    resourceClonedPayloadContentByteSize :: Maybe Integer,
    resourceClonedPayloadStorageUri :: Maybe Text,
    resourceClonedPayloadParentResourceId :: ResourceId,
    resourceClonedPayloadEntityTypes :: Maybe [Text],
    resourceClonedPayloadLanguage :: Maybe Text,
    resourceClonedPayloadCreator :: Maybe Agent,
    resourceClonedPayloadWasAttributedTo :: Maybe OneOrMoreAgents
  }
  deriving (Eq, Show)

instance FromJSON ResourceClonedPayload where parseJSON = checked "ResourceClonedPayload" $ withObject "ResourceClonedPayload" (\fields -> ResourceClonedPayload <$> (fields .: "name") <*> (fields .: "format") <*> (fields .: "contentChecksum") <*> optional fields "contentByteSize" <*> optional fields "storageUri" <*> (fields .: "parentResourceId") <*> optional fields "entityTypes" <*> optional fields "language" <*> optional fields "creator" <*> optional fields "wasAttributedTo")

instance ToJSON ResourceClonedPayload where toJSON value = Object (KM.fromList (concat [[("name", toJSON (resourceClonedPayloadName value))], [("format", toJSON (resourceClonedPayloadFormat value))], [("contentChecksum", toJSON (resourceClonedPayloadContentChecksum value))], optionalPair "contentByteSize" (resourceClonedPayloadContentByteSize value), optionalPair "storageUri" (resourceClonedPayloadStorageUri value), [("parentResourceId", toJSON (resourceClonedPayloadParentResourceId value))], optionalPair "entityTypes" (resourceClonedPayloadEntityTypes value), optionalPair "language" (resourceClonedPayloadLanguage value), optionalPair "creator" (resourceClonedPayloadCreator value), optionalPair "wasAttributedTo" (resourceClonedPayloadWasAttributedTo value)]))
