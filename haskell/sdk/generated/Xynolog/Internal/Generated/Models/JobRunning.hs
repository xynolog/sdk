-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobRunning (JobRunning (..), JobRunningStatus (..), jobRunningStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobMetadata
import Xynolog.Internal.Generated.Models.JobParams
import Xynolog.Internal.Generated.Models.JobStoredProgress

data JobRunning = JobRunning
  { jobRunningMetadata :: JobMetadata,
    jobRunningParams :: JobParams,
    jobRunningProgress :: JobStoredProgress,
    jobRunningStartedAt :: Text,
    jobRunningStatus :: JobRunningStatus
  }
  deriving (Eq, Show)

instance FromJSON JobRunning where parseJSON = checked "JobRunning" $ withObject "JobRunning" (\fields -> JobRunning <$> (fields .: "metadata") <*> (fields .: "params") <*> (fields .: "progress") <*> (fields .: "startedAt") <*> (fields .: "status"))

instance ToJSON JobRunning where toJSON value = Object (KM.fromList (concat [[("metadata", toJSON (jobRunningMetadata value))], [("params", toJSON (jobRunningParams value))], [("progress", toJSON (jobRunningProgress value))], [("startedAt", toJSON (jobRunningStartedAt value))], [("status", toJSON (jobRunningStatus value))]]))

data JobRunningStatus = JobRunningStatusRunning deriving (Eq, Show)

instance FromJSON JobRunningStatus where parseJSON = checked "JobRunningStatus" $ \value -> if value == String "running" then pure JobRunningStatusRunning else fail "unknown enumeration member"

instance ToJSON JobRunningStatus where toJSON JobRunningStatusRunning = String "running"

jobRunningStatusText :: JobRunningStatus -> Text
jobRunningStatusText JobRunningStatusRunning = "running"
