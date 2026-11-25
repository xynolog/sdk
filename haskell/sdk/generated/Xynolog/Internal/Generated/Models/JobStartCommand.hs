-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobStartCommand (JobStartCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data JobStartCommand = JobStartCommand
  { jobStartCommandUserId :: Maybe UserId,
    jobStartCommandAnnotationId :: Maybe AnnotationId,
    jobStartCommandAttempt :: Maybe Integer,
    jobStartCommandJobId :: JobId,
    jobStartCommandJobType :: JobType,
    jobStartCommandResourceId :: ResourceId,
    jobStartCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobStartCommand where parseJSON = checked "JobStartCommand" $ withObject "JobStartCommand" (\fields -> JobStartCommand <$> optional fields "_userId" <*> optional fields "annotationId" <*> optional fields "attempt" <*> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "resourceId") <*> traverse parseJSON (withoutFields ["_userId", "annotationId", "attempt", "jobId", "jobType", "resourceId"] fields))

instance ToJSON JobStartCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (jobStartCommandUserId value), optionalPair "annotationId" (jobStartCommandAnnotationId value), optionalPair "attempt" (jobStartCommandAttempt value), [("jobId", toJSON (jobStartCommandJobId value))], [("jobType", toJSON (jobStartCommandJobType value))], [("resourceId", toJSON (jobStartCommandResourceId value))]]) <> fmap toJSON (withoutFields ["_userId", "annotationId", "attempt", "jobId", "jobType", "resourceId"] (jobStartCommandAdditionalProperties value)))
