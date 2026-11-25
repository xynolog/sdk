-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobStatusResponse (JobStatusResponse (..), JobStatusResponseStatus (..), jobStatusResponseStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FailureClass
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobStoredProgress
import Xynolog.Internal.Generated.Models.JobStoredResult
import Xynolog.Internal.Generated.Models.JobType
import Xynolog.Internal.Generated.Models.UserId

data JobStatusResponse = JobStatusResponse
  { jobStatusResponseJobId :: JobId,
    jobStatusResponseType :: JobType,
    jobStatusResponseStatus :: JobStatusResponseStatus,
    jobStatusResponseUserId :: UserId,
    jobStatusResponseCreated :: Text,
    jobStatusResponseStartedAt :: Maybe Text,
    jobStatusResponseCompletedAt :: Maybe Text,
    jobStatusResponseError :: Maybe Text,
    jobStatusResponseFailureClass :: Maybe FailureClass,
    jobStatusResponseProgress :: Maybe JobStoredProgress,
    jobStatusResponseResult :: Maybe JobStoredResult
  }
  deriving (Eq, Show)

instance FromJSON JobStatusResponse where parseJSON = checked "JobStatusResponse" $ withObject "JobStatusResponse" (\fields -> JobStatusResponse <$> (fields .: "jobId") <*> (fields .: "type") <*> (fields .: "status") <*> (fields .: "userId") <*> (fields .: "created") <*> optional fields "startedAt" <*> optional fields "completedAt" <*> optional fields "error" <*> optional fields "failureClass" <*> optional fields "progress" <*> optional fields "result")

instance ToJSON JobStatusResponse where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (jobStatusResponseJobId value))], [("type", toJSON (jobStatusResponseType value))], [("status", toJSON (jobStatusResponseStatus value))], [("userId", toJSON (jobStatusResponseUserId value))], [("created", toJSON (jobStatusResponseCreated value))], optionalPair "startedAt" (jobStatusResponseStartedAt value), optionalPair "completedAt" (jobStatusResponseCompletedAt value), optionalPair "error" (jobStatusResponseError value), optionalPair "failureClass" (jobStatusResponseFailureClass value), optionalPair "progress" (jobStatusResponseProgress value), optionalPair "result" (jobStatusResponseResult value)]))

data JobStatusResponseStatus = JobStatusResponseStatusPending | JobStatusResponseStatusRunning | JobStatusResponseStatusComplete | JobStatusResponseStatusFailed | JobStatusResponseStatusCancelled deriving (Eq, Show)

instance FromJSON JobStatusResponseStatus where parseJSON = checked "JobStatusResponseStatus" $ \value -> if value == String "pending" then pure JobStatusResponseStatusPending else if value == String "running" then pure JobStatusResponseStatusRunning else if value == String "complete" then pure JobStatusResponseStatusComplete else if value == String "failed" then pure JobStatusResponseStatusFailed else if value == String "cancelled" then pure JobStatusResponseStatusCancelled else fail "unknown enumeration member"

instance ToJSON JobStatusResponseStatus where
  toJSON JobStatusResponseStatusPending = String "pending"
  toJSON JobStatusResponseStatusRunning = String "running"
  toJSON JobStatusResponseStatusComplete = String "complete"
  toJSON JobStatusResponseStatusFailed = String "failed"
  toJSON JobStatusResponseStatusCancelled = String "cancelled"

jobStatusResponseStatusText :: JobStatusResponseStatus -> Text
jobStatusResponseStatusText JobStatusResponseStatusPending = "pending"
jobStatusResponseStatusText JobStatusResponseStatusRunning = "running"
jobStatusResponseStatusText JobStatusResponseStatusComplete = "complete"
jobStatusResponseStatusText JobStatusResponseStatusFailed = "failed"
jobStatusResponseStatusText JobStatusResponseStatusCancelled = "cancelled"
