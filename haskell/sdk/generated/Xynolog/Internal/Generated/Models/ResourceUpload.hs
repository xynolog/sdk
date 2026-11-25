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
  { resourceUploadName :: Text,
    resourceUploadFile :: Text,
    resourceUploadFormat :: Text,
    resourceUploadStorageUri :: Text,
    resourceUploadLanguage :: Maybe Text,
    resourceUploadEntityTypes :: Maybe Text,
    resourceUploadSourceAnnotationId :: Maybe AnnotationId,
    resourceUploadSourceResourceId :: Maybe ResourceId,
    resourceUploadGenerationPrompt :: Maybe Text,
    resourceUploadGenerator :: Maybe Text,
    resourceUploadJobId :: Maybe JobId,
    resourceUploadIsDraft :: Maybe Text,
    resourceUploadCloneToken :: Maybe Text,
    resourceUploadArchiveOriginal :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ResourceUpload where parseJSON = checked "ResourceUpload" $ withObject "ResourceUpload" (\fields -> ResourceUpload <$> (fields .: "name") <*> (fields .: "file") <*> (fields .: "format") <*> (fields .: "storageUri") <*> optional fields "language" <*> optional fields "entityTypes" <*> optional fields "sourceAnnotationId" <*> optional fields "sourceResourceId" <*> optional fields "generationPrompt" <*> optional fields "generator" <*> optional fields "jobId" <*> optional fields "isDraft" <*> optional fields "cloneToken" <*> optional fields "archiveOriginal")

instance ToJSON ResourceUpload where toJSON value = Object (KM.fromList (concat [[("name", toJSON (resourceUploadName value))], [("file", toJSON (resourceUploadFile value))], [("format", toJSON (resourceUploadFormat value))], [("storageUri", toJSON (resourceUploadStorageUri value))], optionalPair "language" (resourceUploadLanguage value), optionalPair "entityTypes" (resourceUploadEntityTypes value), optionalPair "sourceAnnotationId" (resourceUploadSourceAnnotationId value), optionalPair "sourceResourceId" (resourceUploadSourceResourceId value), optionalPair "generationPrompt" (resourceUploadGenerationPrompt value), optionalPair "generator" (resourceUploadGenerator value), optionalPair "jobId" (resourceUploadJobId value), optionalPair "isDraft" (resourceUploadIsDraft value), optionalPair "cloneToken" (resourceUploadCloneToken value), optionalPair "archiveOriginal" (resourceUploadArchiveOriginal value)]))
