-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldCreateCommand (YieldCreateCommand (..), YieldCreateCommandGeneratedFrom (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ContentFormat
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.OneOrMoreAgents
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data YieldCreateCommand = YieldCreateCommand
  { yieldCreateCommandUserId :: Maybe UserId,
    yieldCreateCommandRoles :: Maybe [Text],
    yieldCreateCommandJobId :: Maybe JobId,
    yieldCreateCommandName :: Text,
    yieldCreateCommandStorageUri :: Text,
    yieldCreateCommandContentChecksum :: Text,
    yieldCreateCommandByteSize :: Integer,
    yieldCreateCommandFormat :: ContentFormat,
    yieldCreateCommandLanguage :: Maybe Text,
    yieldCreateCommandEntityTypes :: Maybe [Text],
    yieldCreateCommandIsDraft :: Maybe Bool,
    yieldCreateCommandGeneratedFrom :: Maybe YieldCreateCommandGeneratedFrom,
    yieldCreateCommandGenerationPrompt :: Maybe Text,
    yieldCreateCommandGenerator :: Maybe OneOrMoreAgents
  }
  deriving (Eq, Show)

instance FromJSON YieldCreateCommand where parseJSON = checked "YieldCreateCommand" $ withObject "YieldCreateCommand" (\fields -> YieldCreateCommand <$> optional fields "_userId" <*> optional fields "_roles" <*> optional fields "jobId" <*> (fields .: "name") <*> (fields .: "storageUri") <*> (fields .: "contentChecksum") <*> (fields .: "byteSize") <*> (fields .: "format") <*> optional fields "language" <*> optional fields "entityTypes" <*> optional fields "isDraft" <*> optional fields "generatedFrom" <*> optional fields "generationPrompt" <*> optional fields "generator")

instance ToJSON YieldCreateCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (yieldCreateCommandUserId value), optionalPair "_roles" (yieldCreateCommandRoles value), optionalPair "jobId" (yieldCreateCommandJobId value), [("name", toJSON (yieldCreateCommandName value))], [("storageUri", toJSON (yieldCreateCommandStorageUri value))], [("contentChecksum", toJSON (yieldCreateCommandContentChecksum value))], [("byteSize", toJSON (yieldCreateCommandByteSize value))], [("format", toJSON (yieldCreateCommandFormat value))], optionalPair "language" (yieldCreateCommandLanguage value), optionalPair "entityTypes" (yieldCreateCommandEntityTypes value), optionalPair "isDraft" (yieldCreateCommandIsDraft value), optionalPair "generatedFrom" (yieldCreateCommandGeneratedFrom value), optionalPair "generationPrompt" (yieldCreateCommandGenerationPrompt value), optionalPair "generator" (yieldCreateCommandGenerator value)]))

data YieldCreateCommandGeneratedFrom = YieldCreateCommandGeneratedFrom
  { yieldCreateCommandGeneratedFromResourceId :: Maybe ResourceId,
    yieldCreateCommandGeneratedFromAnnotationId :: Maybe AnnotationId
  }
  deriving (Eq, Show)

instance FromJSON YieldCreateCommandGeneratedFrom where parseJSON = checked "YieldCreateCommandGeneratedFrom" $ withObject "YieldCreateCommandGeneratedFrom" (\fields -> YieldCreateCommandGeneratedFrom <$> optional fields "resourceId" <*> optional fields "annotationId")

instance ToJSON YieldCreateCommandGeneratedFrom where toJSON value = Object (KM.fromList (concat [optionalPair "resourceId" (yieldCreateCommandGeneratedFromResourceId value), optionalPair "annotationId" (yieldCreateCommandGeneratedFromAnnotationId value)]))
