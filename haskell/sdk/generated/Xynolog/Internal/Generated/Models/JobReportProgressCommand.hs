-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobReportProgressCommand (JobReportProgressCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobProgress
import Xynolog.Internal.Generated.Models.JobType
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data JobReportProgressCommand = JobReportProgressCommand
  { jobReportProgressCommandUserId :: Maybe UserId,
    jobReportProgressCommandAnnotationId :: Maybe AnnotationId,
    jobReportProgressCommandAttempt :: Maybe Integer,
    jobReportProgressCommandJobId :: JobId,
    jobReportProgressCommandJobType :: JobType,
    jobReportProgressCommandPercentage :: Scientific,
    jobReportProgressCommandProgress :: Maybe JobProgress,
    jobReportProgressCommandResourceId :: ResourceId,
    jobReportProgressCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobReportProgressCommand where parseJSON = checked "JobReportProgressCommand" $ withObject "JobReportProgressCommand" (\fields -> JobReportProgressCommand <$> optional fields "_userId" <*> optional fields "annotationId" <*> optional fields "attempt" <*> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "percentage") <*> optional fields "progress" <*> (fields .: "resourceId") <*> traverse parseJSON (withoutFields ["_userId", "annotationId", "attempt", "jobId", "jobType", "percentage", "progress", "resourceId"] fields))

instance ToJSON JobReportProgressCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (jobReportProgressCommandUserId value), optionalPair "annotationId" (jobReportProgressCommandAnnotationId value), optionalPair "attempt" (jobReportProgressCommandAttempt value), [("jobId", toJSON (jobReportProgressCommandJobId value))], [("jobType", toJSON (jobReportProgressCommandJobType value))], [("percentage", toJSON (jobReportProgressCommandPercentage value))], optionalPair "progress" (jobReportProgressCommandProgress value), [("resourceId", toJSON (jobReportProgressCommandResourceId value))]]) <> fmap toJSON (withoutFields ["_userId", "annotationId", "attempt", "jobId", "jobType", "percentage", "progress", "resourceId"] (jobReportProgressCommandAdditionalProperties value)))
