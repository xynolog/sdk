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
    jobStartCommandResourceId :: ResourceId,
    jobStartCommandJobId :: JobId,
    jobStartCommandJobType :: JobType,
    jobStartCommandAnnotationId :: Maybe AnnotationId,
    jobStartCommandAttempt :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON JobStartCommand where parseJSON = checked "JobStartCommand" $ withObject "JobStartCommand" (\fields -> JobStartCommand <$> optional fields "_userId" <*> (fields .: "resourceId") <*> (fields .: "jobId") <*> (fields .: "jobType") <*> optional fields "annotationId" <*> optional fields "attempt")

instance ToJSON JobStartCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (jobStartCommandUserId value), [("resourceId", toJSON (jobStartCommandResourceId value))], [("jobId", toJSON (jobStartCommandJobId value))], [("jobType", toJSON (jobStartCommandJobType value))], optionalPair "annotationId" (jobStartCommandAnnotationId value), optionalPair "attempt" (jobStartCommandAttempt value)]))
