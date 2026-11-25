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
  { jobFailedPayloadJobId :: JobId,
    jobFailedPayloadJobType :: JobType,
    jobFailedPayloadAttempt :: Maybe Integer,
    jobFailedPayloadAnnotationId :: Maybe AnnotationId,
    jobFailedPayloadError :: Text,
    jobFailedPayloadFailureClass :: Maybe FailureClass,
    jobFailedPayloadWillRetry :: Maybe Bool,
    jobFailedPayloadDurability :: Maybe DurabilityEvidence
  }
  deriving (Eq, Show)

instance FromJSON JobFailedPayload where parseJSON = checked "JobFailedPayload" $ withObject "JobFailedPayload" (\fields -> JobFailedPayload <$> (fields .: "jobId") <*> (fields .: "jobType") <*> optional fields "attempt" <*> optional fields "annotationId" <*> (fields .: "error") <*> optional fields "failureClass" <*> optional fields "willRetry" <*> optional fields "durability")

instance ToJSON JobFailedPayload where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (jobFailedPayloadJobId value))], [("jobType", toJSON (jobFailedPayloadJobType value))], optionalPair "attempt" (jobFailedPayloadAttempt value), optionalPair "annotationId" (jobFailedPayloadAnnotationId value), [("error", toJSON (jobFailedPayloadError value))], optionalPair "failureClass" (jobFailedPayloadFailureClass value), optionalPair "willRetry" (jobFailedPayloadWillRetry value), optionalPair "durability" (jobFailedPayloadDurability value)]))
