-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobFailCommand (JobFailCommand (..), JobFailCommandUnitCursors (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.DurabilityEvidence
import Xynolog.Internal.Generated.Models.FailureClass
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UnitCursor
import Xynolog.Internal.Generated.Models.UserId

data JobFailCommand = JobFailCommand
  { jobFailCommandUserId :: Maybe UserId,
    jobFailCommandAnnotationId :: Maybe AnnotationId,
    jobFailCommandAttempt :: Maybe Integer,
    jobFailCommandCompletedUnits :: Maybe [Text],
    jobFailCommandDurability :: Maybe DurabilityEvidence,
    jobFailCommandError :: Text,
    jobFailCommandFailureClass :: Maybe FailureClass,
    jobFailCommandJobId :: JobId,
    jobFailCommandJobType :: JobType,
    jobFailCommandResourceId :: ResourceId,
    jobFailCommandUnitCursors :: Maybe JobFailCommandUnitCursors,
    jobFailCommandWillRetry :: Maybe Bool,
    jobFailCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobFailCommand where parseJSON = checked "JobFailCommand" $ withObject "JobFailCommand" (\fields -> JobFailCommand <$> optional fields "_userId" <*> optional fields "annotationId" <*> optional fields "attempt" <*> optional fields "completedUnits" <*> optional fields "durability" <*> (fields .: "error") <*> optional fields "failureClass" <*> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "resourceId") <*> optional fields "unitCursors" <*> optional fields "willRetry" <*> traverse parseJSON (withoutFields ["_userId", "annotationId", "attempt", "completedUnits", "durability", "error", "failureClass", "jobId", "jobType", "resourceId", "unitCursors", "willRetry"] fields))

instance ToJSON JobFailCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (jobFailCommandUserId value), optionalPair "annotationId" (jobFailCommandAnnotationId value), optionalPair "attempt" (jobFailCommandAttempt value), optionalPair "completedUnits" (jobFailCommandCompletedUnits value), optionalPair "durability" (jobFailCommandDurability value), [("error", toJSON (jobFailCommandError value))], optionalPair "failureClass" (jobFailCommandFailureClass value), [("jobId", toJSON (jobFailCommandJobId value))], [("jobType", toJSON (jobFailCommandJobType value))], [("resourceId", toJSON (jobFailCommandResourceId value))], optionalPair "unitCursors" (jobFailCommandUnitCursors value), optionalPair "willRetry" (jobFailCommandWillRetry value)]) <> fmap toJSON (withoutFields ["_userId", "annotationId", "attempt", "completedUnits", "durability", "error", "failureClass", "jobId", "jobType", "resourceId", "unitCursors", "willRetry"] (jobFailCommandAdditionalProperties value)))

data JobFailCommandUnitCursors = JobFailCommandUnitCursors
  { jobFailCommandUnitCursorsAdditionalProperties :: KM.KeyMap UnitCursor
  }
  deriving (Eq, Show)

instance FromJSON JobFailCommandUnitCursors where parseJSON = checked "JobFailCommandUnitCursors" $ withObject "JobFailCommandUnitCursors" (\fields -> JobFailCommandUnitCursors <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobFailCommandUnitCursors where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobFailCommandUnitCursorsAdditionalProperties value)))
