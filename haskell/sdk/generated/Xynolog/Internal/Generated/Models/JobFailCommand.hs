-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobFailCommand (JobFailCommand (..)) where

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
    jobFailCommandResourceId :: ResourceId,
    jobFailCommandJobId :: JobId,
    jobFailCommandJobType :: JobType,
    jobFailCommandAttempt :: Maybe Integer,
    jobFailCommandAnnotationId :: Maybe AnnotationId,
    jobFailCommandError :: Text,
    jobFailCommandCompletedUnits :: Maybe [Text],
    jobFailCommandUnitCursors :: Maybe (KM.KeyMap UnitCursor),
    jobFailCommandFailureClass :: Maybe FailureClass,
    jobFailCommandWillRetry :: Maybe Bool,
    jobFailCommandDurability :: Maybe DurabilityEvidence
  }
  deriving (Eq, Show)

instance FromJSON JobFailCommand where parseJSON = checked "JobFailCommand" $ withObject "JobFailCommand" (\fields -> JobFailCommand <$> optional fields "_userId" <*> (fields .: "resourceId") <*> (fields .: "jobId") <*> (fields .: "jobType") <*> optional fields "attempt" <*> optional fields "annotationId" <*> (fields .: "error") <*> optional fields "completedUnits" <*> optional fields "unitCursors" <*> optional fields "failureClass" <*> optional fields "willRetry" <*> optional fields "durability")

instance ToJSON JobFailCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (jobFailCommandUserId value), [("resourceId", toJSON (jobFailCommandResourceId value))], [("jobId", toJSON (jobFailCommandJobId value))], [("jobType", toJSON (jobFailCommandJobType value))], optionalPair "attempt" (jobFailCommandAttempt value), optionalPair "annotationId" (jobFailCommandAnnotationId value), [("error", toJSON (jobFailCommandError value))], optionalPair "completedUnits" (jobFailCommandCompletedUnits value), optionalPair "unitCursors" (jobFailCommandUnitCursors value), optionalPair "failureClass" (jobFailCommandFailureClass value), optionalPair "willRetry" (jobFailCommandWillRetry value), optionalPair "durability" (jobFailCommandDurability value)]))
