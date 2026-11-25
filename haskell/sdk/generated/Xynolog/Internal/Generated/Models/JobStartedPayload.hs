-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobStartedPayload (JobStartedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType

data JobStartedPayload = JobStartedPayload
  { jobStartedPayloadAnnotationId :: Maybe AnnotationId,
    jobStartedPayloadJobId :: JobId,
    jobStartedPayloadJobType :: JobType,
    jobStartedPayloadTotalSteps :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON JobStartedPayload where parseJSON = checked "JobStartedPayload" $ withObject "JobStartedPayload" (\fields -> JobStartedPayload <$> optional fields "annotationId" <*> (fields .: "jobId") <*> (fields .: "jobType") <*> optional fields "totalSteps")

instance ToJSON JobStartedPayload where toJSON value = Object (KM.fromList (concat [optionalPair "annotationId" (jobStartedPayloadAnnotationId value), [("jobId", toJSON (jobStartedPayloadJobId value))], [("jobType", toJSON (jobStartedPayloadJobType value))], optionalPair "totalSteps" (jobStartedPayloadTotalSteps value)]))
