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
  { jobCompletedPayloadJobId :: JobId,
    jobCompletedPayloadJobType :: JobType,
    jobCompletedPayloadAttempt :: Maybe Integer,
    jobCompletedPayloadAnnotationId :: Maybe AnnotationId,
    jobCompletedPayloadTotalSteps :: Maybe Integer,
    jobCompletedPayloadFoundCount :: Maybe Integer,
    jobCompletedPayloadResultResourceId :: Maybe ResourceId,
    jobCompletedPayloadAnnotationUri :: Maybe Text,
    jobCompletedPayloadResult :: Maybe JobCompletedPayloadResult,
    jobCompletedPayloadDurability :: Maybe DurabilityEvidence
  }
  deriving (Eq, Show)

instance FromJSON JobCompletedPayload where parseJSON = checked "JobCompletedPayload" $ withObject "JobCompletedPayload" (\fields -> JobCompletedPayload <$> (fields .: "jobId") <*> (fields .: "jobType") <*> optional fields "attempt" <*> optional fields "annotationId" <*> optional fields "totalSteps" <*> optional fields "foundCount" <*> optional fields "resultResourceId" <*> optional fields "annotationUri" <*> optional fields "result" <*> optional fields "durability")

instance ToJSON JobCompletedPayload where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (jobCompletedPayloadJobId value))], [("jobType", toJSON (jobCompletedPayloadJobType value))], optionalPair "attempt" (jobCompletedPayloadAttempt value), optionalPair "annotationId" (jobCompletedPayloadAnnotationId value), optionalPair "totalSteps" (jobCompletedPayloadTotalSteps value), optionalPair "foundCount" (jobCompletedPayloadFoundCount value), optionalPair "resultResourceId" (jobCompletedPayloadResultResourceId value), optionalPair "annotationUri" (jobCompletedPayloadAnnotationUri value), optionalPair "result" (jobCompletedPayloadResult value), optionalPair "durability" (jobCompletedPayloadDurability value)]))

data JobCompletedPayloadResult = JobCompletedPayloadResult
  { jobCompletedPayloadResultAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobCompletedPayloadResult where parseJSON = checked "JobCompletedPayloadResult" $ withObject "JobCompletedPayloadResult" (\fields -> JobCompletedPayloadResult <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobCompletedPayloadResult where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobCompletedPayloadResultAdditionalProperties value)))
