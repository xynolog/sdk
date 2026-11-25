-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobCompletedPayload (JobCompletedPayload (..), JobCompletedPayloadResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.DurabilityEvidence
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType
import Xynolog.Internal.Generated.Models.ResourceId

data JobCompletedPayload = JobCompletedPayload
  { jobCompletedPayloadAnnotationId :: Maybe AnnotationId,
    jobCompletedPayloadAnnotationUri :: Maybe Text,
    jobCompletedPayloadAttempt :: Maybe Integer,
    jobCompletedPayloadDurability :: Maybe DurabilityEvidence,
    jobCompletedPayloadFoundCount :: Maybe Integer,
    jobCompletedPayloadJobId :: JobId,
    jobCompletedPayloadJobType :: JobType,
    jobCompletedPayloadResult :: Maybe JobCompletedPayloadResult,
    jobCompletedPayloadResultResourceId :: Maybe ResourceId,
    jobCompletedPayloadTotalSteps :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON JobCompletedPayload where parseJSON = checked "JobCompletedPayload" $ withObject "JobCompletedPayload" (\fields -> JobCompletedPayload <$> optional fields "annotationId" <*> optional fields "annotationUri" <*> optional fields "attempt" <*> optional fields "durability" <*> optional fields "foundCount" <*> (fields .: "jobId") <*> (fields .: "jobType") <*> optional fields "result" <*> optional fields "resultResourceId" <*> optional fields "totalSteps")

instance ToJSON JobCompletedPayload where toJSON value = Object (KM.fromList (concat [optionalPair "annotationId" (jobCompletedPayloadAnnotationId value), optionalPair "annotationUri" (jobCompletedPayloadAnnotationUri value), optionalPair "attempt" (jobCompletedPayloadAttempt value), optionalPair "durability" (jobCompletedPayloadDurability value), optionalPair "foundCount" (jobCompletedPayloadFoundCount value), [("jobId", toJSON (jobCompletedPayloadJobId value))], [("jobType", toJSON (jobCompletedPayloadJobType value))], optionalPair "result" (jobCompletedPayloadResult value), optionalPair "resultResourceId" (jobCompletedPayloadResultResourceId value), optionalPair "totalSteps" (jobCompletedPayloadTotalSteps value)]))

data JobCompletedPayloadResult = JobCompletedPayloadResult
  { jobCompletedPayloadResultAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobCompletedPayloadResult where parseJSON = checked "JobCompletedPayloadResult" $ withObject "JobCompletedPayloadResult" (\fields -> JobCompletedPayloadResult <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobCompletedPayloadResult where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobCompletedPayloadResultAdditionalProperties value)))
