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
  { yieldCreateCommandRoles :: Maybe [Text],
    yieldCreateCommandUserId :: Maybe UserId,
    yieldCreateCommandByteSize :: Integer,
    yieldCreateCommandContentChecksum :: Text,
    yieldCreateCommandEntityTypes :: Maybe [Text],
    yieldCreateCommandFormat :: ContentFormat,
    yieldCreateCommandGeneratedFrom :: Maybe YieldCreateCommandGeneratedFrom,
    yieldCreateCommandGenerationPrompt :: Maybe Text,
    yieldCreateCommandGenerator :: Maybe OneOrMoreAgents,
    yieldCreateCommandIsDraft :: Maybe Bool,
    yieldCreateCommandJobId :: Maybe JobId,
    yieldCreateCommandLanguage :: Maybe Text,
    yieldCreateCommandName :: Text,
    yieldCreateCommandStorageUri :: Text,
    yieldCreateCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON YieldCreateCommand where parseJSON = checked "YieldCreateCommand" $ withObject "YieldCreateCommand" (\fields -> YieldCreateCommand <$> optional fields "_roles" <*> optional fields "_userId" <*> (fields .: "byteSize") <*> (fields .: "contentChecksum") <*> optional fields "entityTypes" <*> (fields .: "format") <*> optional fields "generatedFrom" <*> optional fields "generationPrompt" <*> optional fields "generator" <*> optional fields "isDraft" <*> optional fields "jobId" <*> optional fields "language" <*> (fields .: "name") <*> (fields .: "storageUri") <*> traverse parseJSON (withoutFields ["_roles", "_userId", "byteSize", "contentChecksum", "entityTypes", "format", "generatedFrom", "generationPrompt", "generator", "isDraft", "jobId", "language", "name", "storageUri"] fields))

instance ToJSON YieldCreateCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_roles" (yieldCreateCommandRoles value), optionalPair "_userId" (yieldCreateCommandUserId value), [("byteSize", toJSON (yieldCreateCommandByteSize value))], [("contentChecksum", toJSON (yieldCreateCommandContentChecksum value))], optionalPair "entityTypes" (yieldCreateCommandEntityTypes value), [("format", toJSON (yieldCreateCommandFormat value))], optionalPair "generatedFrom" (yieldCreateCommandGeneratedFrom value), optionalPair "generationPrompt" (yieldCreateCommandGenerationPrompt value), optionalPair "generator" (yieldCreateCommandGenerator value), optionalPair "isDraft" (yieldCreateCommandIsDraft value), optionalPair "jobId" (yieldCreateCommandJobId value), optionalPair "language" (yieldCreateCommandLanguage value), [("name", toJSON (yieldCreateCommandName value))], [("storageUri", toJSON (yieldCreateCommandStorageUri value))]]) <> fmap toJSON (withoutFields ["_roles", "_userId", "byteSize", "contentChecksum", "entityTypes", "format", "generatedFrom", "generationPrompt", "generator", "isDraft", "jobId", "language", "name", "storageUri"] (yieldCreateCommandAdditionalProperties value)))

data YieldCreateCommandGeneratedFrom = YieldCreateCommandGeneratedFrom
  { yieldCreateCommandGeneratedFromAnnotationId :: Maybe AnnotationId,
    yieldCreateCommandGeneratedFromResourceId :: Maybe ResourceId,
    yieldCreateCommandGeneratedFromAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON YieldCreateCommandGeneratedFrom where parseJSON = checked "YieldCreateCommandGeneratedFrom" $ withObject "YieldCreateCommandGeneratedFrom" (\fields -> YieldCreateCommandGeneratedFrom <$> optional fields "annotationId" <*> optional fields "resourceId" <*> traverse parseJSON (withoutFields ["annotationId", "resourceId"] fields))

instance ToJSON YieldCreateCommandGeneratedFrom where toJSON value = Object (KM.fromList (concat [optionalPair "annotationId" (yieldCreateCommandGeneratedFromAnnotationId value), optionalPair "resourceId" (yieldCreateCommandGeneratedFromResourceId value)]) <> fmap toJSON (withoutFields ["annotationId", "resourceId"] (yieldCreateCommandGeneratedFromAdditionalProperties value)))
