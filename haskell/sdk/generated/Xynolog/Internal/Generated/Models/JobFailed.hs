-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobFailed (JobFailed (..), JobFailedStatus (..), jobFailedStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FailureClass
import Xynolog.Internal.Generated.Models.JobMetadata
import Xynolog.Internal.Generated.Models.JobParams

data JobFailed = JobFailed
  { jobFailedCompletedAt :: Text,
    jobFailedError :: Text,
    jobFailedFailureClass :: Maybe FailureClass,
    jobFailedMetadata :: JobMetadata,
    jobFailedParams :: JobParams,
    jobFailedStartedAt :: Maybe Text,
    jobFailedStatus :: JobFailedStatus
  }
  deriving (Eq, Show)

instance FromJSON JobFailed where parseJSON = checked "JobFailed" $ withObject "JobFailed" (\fields -> JobFailed <$> (fields .: "completedAt") <*> (fields .: "error") <*> optional fields "failureClass" <*> (fields .: "metadata") <*> (fields .: "params") <*> optional fields "startedAt" <*> (fields .: "status"))

instance ToJSON JobFailed where toJSON value = Object (KM.fromList (concat [[("completedAt", toJSON (jobFailedCompletedAt value))], [("error", toJSON (jobFailedError value))], optionalPair "failureClass" (jobFailedFailureClass value), [("metadata", toJSON (jobFailedMetadata value))], [("params", toJSON (jobFailedParams value))], optionalPair "startedAt" (jobFailedStartedAt value), [("status", toJSON (jobFailedStatus value))]]))

data JobFailedStatus = JobFailedStatusFailed deriving (Eq, Show)

instance FromJSON JobFailedStatus where parseJSON = checked "JobFailedStatus" $ \value -> if value == String "failed" then pure JobFailedStatusFailed else fail "unknown enumeration member"

instance ToJSON JobFailedStatus where toJSON JobFailedStatusFailed = String "failed"

jobFailedStatusText :: JobFailedStatus -> Text
jobFailedStatusText JobFailedStatusFailed = "failed"
