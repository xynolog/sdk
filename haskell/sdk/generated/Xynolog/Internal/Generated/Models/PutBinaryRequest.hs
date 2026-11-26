-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.PutBinaryRequest (PutBinaryRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ByteSource
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.OneOrMoreAgents
import Xynolog.Internal.Generated.Models.ResourceId

data PutBinaryRequest = PutBinaryRequest
  { putBinaryRequestName :: Text,
    putBinaryRequestFile :: ByteSource,
    putBinaryRequestFormat :: Text,
    putBinaryRequestStorageUri :: Text,
    putBinaryRequestLanguage :: Maybe Text,
    putBinaryRequestEntityTypes :: Maybe [Text],
    putBinaryRequestSourceAnnotationId :: Maybe AnnotationId,
    putBinaryRequestSourceResourceId :: Maybe ResourceId,
    putBinaryRequestGenerationPrompt :: Maybe Text,
    putBinaryRequestGenerator :: Maybe OneOrMoreAgents,
    putBinaryRequestJobId :: Maybe JobId,
    putBinaryRequestIsDraft :: Maybe Bool,
    putBinaryRequestCloneToken :: Maybe Text,
    putBinaryRequestArchiveOriginal :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON PutBinaryRequest where parseJSON = checked "PutBinaryRequest" $ withObject "PutBinaryRequest" (\fields -> PutBinaryRequest <$> (fields .: "name") <*> (fields .: "file") <*> (fields .: "format") <*> (fields .: "storageUri") <*> optional fields "language" <*> optional fields "entityTypes" <*> optional fields "sourceAnnotationId" <*> optional fields "sourceResourceId" <*> optional fields "generationPrompt" <*> optional fields "generator" <*> optional fields "jobId" <*> optional fields "isDraft" <*> optional fields "cloneToken" <*> optional fields "archiveOriginal")

instance ToJSON PutBinaryRequest where toJSON value = Object (KM.fromList (concat [[("name", toJSON (putBinaryRequestName value))], [("file", toJSON (putBinaryRequestFile value))], [("format", toJSON (putBinaryRequestFormat value))], [("storageUri", toJSON (putBinaryRequestStorageUri value))], optionalPair "language" (putBinaryRequestLanguage value), optionalPair "entityTypes" (putBinaryRequestEntityTypes value), optionalPair "sourceAnnotationId" (putBinaryRequestSourceAnnotationId value), optionalPair "sourceResourceId" (putBinaryRequestSourceResourceId value), optionalPair "generationPrompt" (putBinaryRequestGenerationPrompt value), optionalPair "generator" (putBinaryRequestGenerator value), optionalPair "jobId" (putBinaryRequestJobId value), optionalPair "isDraft" (putBinaryRequestIsDraft value), optionalPair "cloneToken" (putBinaryRequestCloneToken value), optionalPair "archiveOriginal" (putBinaryRequestArchiveOriginal value)]))
