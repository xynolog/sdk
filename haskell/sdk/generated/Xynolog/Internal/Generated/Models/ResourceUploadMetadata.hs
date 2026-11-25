-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceUploadMetadata (ResourceUploadMetadata (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.ResourceId

data ResourceUploadMetadata = ResourceUploadMetadata
  { resourceUploadMetadataArchiveOriginal :: Maybe Text,
    resourceUploadMetadataCloneToken :: Maybe Text,
    resourceUploadMetadataEntityTypes :: Maybe Text,
    resourceUploadMetadataFormat :: Text,
    resourceUploadMetadataGenerationPrompt :: Maybe Text,
    resourceUploadMetadataGenerator :: Maybe Text,
    resourceUploadMetadataIsDraft :: Maybe Text,
    resourceUploadMetadataJobId :: Maybe JobId,
    resourceUploadMetadataLanguage :: Maybe Text,
    resourceUploadMetadataName :: Text,
    resourceUploadMetadataSourceAnnotationId :: Maybe AnnotationId,
    resourceUploadMetadataSourceResourceId :: Maybe ResourceId,
    resourceUploadMetadataStorageUri :: Text
  }
  deriving (Eq, Show)

instance FromJSON ResourceUploadMetadata where parseJSON = checked "ResourceUploadMetadata" $ withObject "ResourceUploadMetadata" (\fields -> ResourceUploadMetadata <$> optional fields "archiveOriginal" <*> optional fields "cloneToken" <*> optional fields "entityTypes" <*> (fields .: "format") <*> optional fields "generationPrompt" <*> optional fields "generator" <*> optional fields "isDraft" <*> optional fields "jobId" <*> optional fields "language" <*> (fields .: "name") <*> optional fields "sourceAnnotationId" <*> optional fields "sourceResourceId" <*> (fields .: "storageUri"))

instance ToJSON ResourceUploadMetadata where toJSON value = Object (KM.fromList (concat [optionalPair "archiveOriginal" (resourceUploadMetadataArchiveOriginal value), optionalPair "cloneToken" (resourceUploadMetadataCloneToken value), optionalPair "entityTypes" (resourceUploadMetadataEntityTypes value), [("format", toJSON (resourceUploadMetadataFormat value))], optionalPair "generationPrompt" (resourceUploadMetadataGenerationPrompt value), optionalPair "generator" (resourceUploadMetadataGenerator value), optionalPair "isDraft" (resourceUploadMetadataIsDraft value), optionalPair "jobId" (resourceUploadMetadataJobId value), optionalPair "language" (resourceUploadMetadataLanguage value), [("name", toJSON (resourceUploadMetadataName value))], optionalPair "sourceAnnotationId" (resourceUploadMetadataSourceAnnotationId value), optionalPair "sourceResourceId" (resourceUploadMetadataSourceResourceId value), [("storageUri", toJSON (resourceUploadMetadataStorageUri value))]]))
