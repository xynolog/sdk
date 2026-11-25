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
  { resourceUploadMetadataName :: Text,
    resourceUploadMetadataFormat :: Text,
    resourceUploadMetadataStorageUri :: Text,
    resourceUploadMetadataLanguage :: Maybe Text,
    resourceUploadMetadataEntityTypes :: Maybe Text,
    resourceUploadMetadataSourceAnnotationId :: Maybe AnnotationId,
    resourceUploadMetadataSourceResourceId :: Maybe ResourceId,
    resourceUploadMetadataGenerationPrompt :: Maybe Text,
    resourceUploadMetadataGenerator :: Maybe Text,
    resourceUploadMetadataJobId :: Maybe JobId,
    resourceUploadMetadataIsDraft :: Maybe Text,
    resourceUploadMetadataCloneToken :: Maybe Text,
    resourceUploadMetadataArchiveOriginal :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ResourceUploadMetadata where parseJSON = checked "ResourceUploadMetadata" $ withObject "ResourceUploadMetadata" (\fields -> ResourceUploadMetadata <$> (fields .: "name") <*> (fields .: "format") <*> (fields .: "storageUri") <*> optional fields "language" <*> optional fields "entityTypes" <*> optional fields "sourceAnnotationId" <*> optional fields "sourceResourceId" <*> optional fields "generationPrompt" <*> optional fields "generator" <*> optional fields "jobId" <*> optional fields "isDraft" <*> optional fields "cloneToken" <*> optional fields "archiveOriginal")

instance ToJSON ResourceUploadMetadata where toJSON value = Object (KM.fromList (concat [[("name", toJSON (resourceUploadMetadataName value))], [("format", toJSON (resourceUploadMetadataFormat value))], [("storageUri", toJSON (resourceUploadMetadataStorageUri value))], optionalPair "language" (resourceUploadMetadataLanguage value), optionalPair "entityTypes" (resourceUploadMetadataEntityTypes value), optionalPair "sourceAnnotationId" (resourceUploadMetadataSourceAnnotationId value), optionalPair "sourceResourceId" (resourceUploadMetadataSourceResourceId value), optionalPair "generationPrompt" (resourceUploadMetadataGenerationPrompt value), optionalPair "generator" (resourceUploadMetadataGenerator value), optionalPair "jobId" (resourceUploadMetadataJobId value), optionalPair "isDraft" (resourceUploadMetadataIsDraft value), optionalPair "cloneToken" (resourceUploadMetadataCloneToken value), optionalPair "archiveOriginal" (resourceUploadMetadataArchiveOriginal value)]))
