-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobCancelCommand (JobCancelCommand (..), JobCancelCommandUnitCursors (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UnitCursor
import Xynolog.Internal.Generated.Models.UserId

data JobCancelCommand = JobCancelCommand
  { jobCancelCommandUserId :: Maybe UserId,
    jobCancelCommandResourceId :: ResourceId,
    jobCancelCommandJobId :: JobId,
    jobCancelCommandJobType :: JobType,
    jobCancelCommandAnnotationId :: Maybe AnnotationId,
    jobCancelCommandCompletedUnits :: Maybe [Text],
    jobCancelCommandUnitCursors :: Maybe JobCancelCommandUnitCursors
  }
  deriving (Eq, Show)

instance FromJSON JobCancelCommand where parseJSON = checked "JobCancelCommand" $ withObject "JobCancelCommand" (\fields -> JobCancelCommand <$> optional fields "_userId" <*> (fields .: "resourceId") <*> (fields .: "jobId") <*> (fields .: "jobType") <*> optional fields "annotationId" <*> optional fields "completedUnits" <*> optional fields "unitCursors")

instance ToJSON JobCancelCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (jobCancelCommandUserId value), [("resourceId", toJSON (jobCancelCommandResourceId value))], [("jobId", toJSON (jobCancelCommandJobId value))], [("jobType", toJSON (jobCancelCommandJobType value))], optionalPair "annotationId" (jobCancelCommandAnnotationId value), optionalPair "completedUnits" (jobCancelCommandCompletedUnits value), optionalPair "unitCursors" (jobCancelCommandUnitCursors value)]))

data JobCancelCommandUnitCursors = JobCancelCommandUnitCursors
  { jobCancelCommandUnitCursorsAdditionalProperties :: KM.KeyMap UnitCursor
  }
  deriving (Eq, Show)

instance FromJSON JobCancelCommandUnitCursors where parseJSON = checked "JobCancelCommandUnitCursors" $ withObject "JobCancelCommandUnitCursors" (\fields -> JobCancelCommandUnitCursors <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobCancelCommandUnitCursors where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobCancelCommandUnitCursorsAdditionalProperties value)))
