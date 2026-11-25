-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobFailedPayload (JobFailedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.DurabilityEvidence
import Xynolog.Internal.Generated.Models.FailureClass
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType

data JobFailedPayload = JobFailedPayload
  { jobFailedPayloadAnnotationId :: Maybe AnnotationId,
    jobFailedPayloadAttempt :: Maybe Integer,
    jobFailedPayloadDurability :: Maybe DurabilityEvidence,
    jobFailedPayloadError :: Text,
    jobFailedPayloadFailureClass :: Maybe FailureClass,
    jobFailedPayloadJobId :: JobId,
    jobFailedPayloadJobType :: JobType,
    jobFailedPayloadWillRetry :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON JobFailedPayload where parseJSON = checked "JobFailedPayload" $ withObject "JobFailedPayload" (\fields -> JobFailedPayload <$> optional fields "annotationId" <*> optional fields "attempt" <*> optional fields "durability" <*> (fields .: "error") <*> optional fields "failureClass" <*> (fields .: "jobId") <*> (fields .: "jobType") <*> optional fields "willRetry")

instance ToJSON JobFailedPayload where toJSON value = Object (KM.fromList (concat [optionalPair "annotationId" (jobFailedPayloadAnnotationId value), optionalPair "attempt" (jobFailedPayloadAttempt value), optionalPair "durability" (jobFailedPayloadDurability value), [("error", toJSON (jobFailedPayloadError value))], optionalPair "failureClass" (jobFailedPayloadFailureClass value), [("jobId", toJSON (jobFailedPayloadJobId value))], [("jobType", toJSON (jobFailedPayloadJobType value))], optionalPair "willRetry" (jobFailedPayloadWillRetry value)]))
