-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceUpload (ResourceUpload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.ResourceId

data ResourceUpload = ResourceUpload
  { resourceUploadArchiveOriginal :: Maybe Text,
    resourceUploadCloneToken :: Maybe Text,
    resourceUploadEntityTypes :: Maybe Text,
    resourceUploadFile :: Text,
    resourceUploadFormat :: Text,
    resourceUploadGenerationPrompt :: Maybe Text,
    resourceUploadGenerator :: Maybe Text,
    resourceUploadIsDraft :: Maybe Text,
    resourceUploadJobId :: Maybe JobId,
    resourceUploadLanguage :: Maybe Text,
    resourceUploadName :: Text,
    resourceUploadSourceAnnotationId :: Maybe AnnotationId,
    resourceUploadSourceResourceId :: Maybe ResourceId,
    resourceUploadStorageUri :: Text
  }
  deriving (Eq, Show)

instance FromJSON ResourceUpload where parseJSON = checked "ResourceUpload" $ withObject "ResourceUpload" (\fields -> ResourceUpload <$> optional fields "archiveOriginal" <*> optional fields "cloneToken" <*> optional fields "entityTypes" <*> (fields .: "file") <*> (fields .: "format") <*> optional fields "generationPrompt" <*> optional fields "generator" <*> optional fields "isDraft" <*> optional fields "jobId" <*> optional fields "language" <*> (fields .: "name") <*> optional fields "sourceAnnotationId" <*> optional fields "sourceResourceId" <*> (fields .: "storageUri"))

instance ToJSON ResourceUpload where toJSON value = Object (KM.fromList (concat [optionalPair "archiveOriginal" (resourceUploadArchiveOriginal value), optionalPair "cloneToken" (resourceUploadCloneToken value), optionalPair "entityTypes" (resourceUploadEntityTypes value), [("file", toJSON (resourceUploadFile value))], [("format", toJSON (resourceUploadFormat value))], optionalPair "generationPrompt" (resourceUploadGenerationPrompt value), optionalPair "generator" (resourceUploadGenerator value), optionalPair "isDraft" (resourceUploadIsDraft value), optionalPair "jobId" (resourceUploadJobId value), optionalPair "language" (resourceUploadLanguage value), [("name", toJSON (resourceUploadName value))], optionalPair "sourceAnnotationId" (resourceUploadSourceAnnotationId value), optionalPair "sourceResourceId" (resourceUploadSourceResourceId value), [("storageUri", toJSON (resourceUploadStorageUri value))]]))
