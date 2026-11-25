-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceCreatedPayload (ResourceCreatedPayload (..), ResourceCreatedPayloadGeneratedFrom (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Agent
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ContentFormat
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.OneOrMoreAgents
import Xynolog.Internal.Generated.Models.ResourceId

data ResourceCreatedPayload = ResourceCreatedPayload
  { resourceCreatedPayloadName :: Text,
    resourceCreatedPayloadFormat :: ContentFormat,
    resourceCreatedPayloadContentChecksum :: Text,
    resourceCreatedPayloadContentByteSize :: Maybe Integer,
    resourceCreatedPayloadEntityTypes :: Maybe [Text],
    resourceCreatedPayloadStorageUri :: Maybe Text,
    resourceCreatedPayloadLanguage :: Maybe Text,
    resourceCreatedPayloadIsDraft :: Maybe Bool,
    resourceCreatedPayloadJobId :: Maybe JobId,
    resourceCreatedPayloadGeneratedFrom :: Maybe ResourceCreatedPayloadGeneratedFrom,
    resourceCreatedPayloadGenerationPrompt :: Maybe Text,
    resourceCreatedPayloadGenerator :: Maybe OneOrMoreAgents,
    resourceCreatedPayloadCreator :: Maybe Agent,
    resourceCreatedPayloadWasAttributedTo :: Maybe OneOrMoreAgents
  }
  deriving (Eq, Show)

instance FromJSON ResourceCreatedPayload where parseJSON = checked "ResourceCreatedPayload" $ withObject "ResourceCreatedPayload" (\fields -> ResourceCreatedPayload <$> (fields .: "name") <*> (fields .: "format") <*> (fields .: "contentChecksum") <*> optional fields "contentByteSize" <*> optional fields "entityTypes" <*> optional fields "storageUri" <*> optional fields "language" <*> optional fields "isDraft" <*> optional fields "jobId" <*> optional fields "generatedFrom" <*> optional fields "generationPrompt" <*> optional fields "generator" <*> optional fields "creator" <*> optional fields "wasAttributedTo")

instance ToJSON ResourceCreatedPayload where toJSON value = Object (KM.fromList (concat [[("name", toJSON (resourceCreatedPayloadName value))], [("format", toJSON (resourceCreatedPayloadFormat value))], [("contentChecksum", toJSON (resourceCreatedPayloadContentChecksum value))], optionalPair "contentByteSize" (resourceCreatedPayloadContentByteSize value), optionalPair "entityTypes" (resourceCreatedPayloadEntityTypes value), optionalPair "storageUri" (resourceCreatedPayloadStorageUri value), optionalPair "language" (resourceCreatedPayloadLanguage value), optionalPair "isDraft" (resourceCreatedPayloadIsDraft value), optionalPair "jobId" (resourceCreatedPayloadJobId value), optionalPair "generatedFrom" (resourceCreatedPayloadGeneratedFrom value), optionalPair "generationPrompt" (resourceCreatedPayloadGenerationPrompt value), optionalPair "generator" (resourceCreatedPayloadGenerator value), optionalPair "creator" (resourceCreatedPayloadCreator value), optionalPair "wasAttributedTo" (resourceCreatedPayloadWasAttributedTo value)]))

data ResourceCreatedPayloadGeneratedFrom = ResourceCreatedPayloadGeneratedFrom
  { resourceCreatedPayloadGeneratedFromResourceId :: ResourceId,
    resourceCreatedPayloadGeneratedFromAnnotationId :: Maybe AnnotationId
  }
  deriving (Eq, Show)

instance FromJSON ResourceCreatedPayloadGeneratedFrom where parseJSON = checked "ResourceCreatedPayloadGeneratedFrom" $ withObject "ResourceCreatedPayloadGeneratedFrom" (\fields -> ResourceCreatedPayloadGeneratedFrom <$> (fields .: "resourceId") <*> optional fields "annotationId")

instance ToJSON ResourceCreatedPayloadGeneratedFrom where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (resourceCreatedPayloadGeneratedFromResourceId value))], optionalPair "annotationId" (resourceCreatedPayloadGeneratedFromAnnotationId value)]))
