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
  { jobStatusResponseCompletedAt :: Maybe Text,
    jobStatusResponseCreated :: Text,
    jobStatusResponseError :: Maybe Text,
    jobStatusResponseFailureClass :: Maybe FailureClass,
    jobStatusResponseJobId :: JobId,
    jobStatusResponseProgress :: Maybe JobStoredProgress,
    jobStatusResponseResult :: Maybe JobStoredResult,
    jobStatusResponseStartedAt :: Maybe Text,
    jobStatusResponseStatus :: JobStatusResponseStatus,
    jobStatusResponseType :: JobType,
    jobStatusResponseUserId :: UserId,
    jobStatusResponseAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobStatusResponse where parseJSON = checked "JobStatusResponse" $ withObject "JobStatusResponse" (\fields -> JobStatusResponse <$> optional fields "completedAt" <*> (fields .: "created") <*> optional fields "error" <*> optional fields "failureClass" <*> (fields .: "jobId") <*> optional fields "progress" <*> optional fields "result" <*> optional fields "startedAt" <*> (fields .: "status") <*> (fields .: "type") <*> (fields .: "userId") <*> traverse parseJSON (withoutFields ["completedAt", "created", "error", "failureClass", "jobId", "progress", "result", "startedAt", "status", "type", "userId"] fields))

instance ToJSON JobStatusResponse where toJSON value = Object (KM.fromList (concat [optionalPair "completedAt" (jobStatusResponseCompletedAt value), [("created", toJSON (jobStatusResponseCreated value))], optionalPair "error" (jobStatusResponseError value), optionalPair "failureClass" (jobStatusResponseFailureClass value), [("jobId", toJSON (jobStatusResponseJobId value))], optionalPair "progress" (jobStatusResponseProgress value), optionalPair "result" (jobStatusResponseResult value), optionalPair "startedAt" (jobStatusResponseStartedAt value), [("status", toJSON (jobStatusResponseStatus value))], [("type", toJSON (jobStatusResponseType value))], [("userId", toJSON (jobStatusResponseUserId value))]]) <> fmap toJSON (withoutFields ["completedAt", "created", "error", "failureClass", "jobId", "progress", "result", "startedAt", "status", "type", "userId"] (jobStatusResponseAdditionalProperties value)))

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
