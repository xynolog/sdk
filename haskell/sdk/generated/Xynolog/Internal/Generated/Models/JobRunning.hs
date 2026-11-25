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
  { jobRunningStatus :: JobRunningStatus,
    jobRunningMetadata :: JobMetadata,
    jobRunningParams :: JobParams,
    jobRunningStartedAt :: Text,
    jobRunningProgress :: JobStoredProgress
  }
  deriving (Eq, Show)

instance FromJSON JobRunning where parseJSON = checked "JobRunning" $ withObject "JobRunning" (\fields -> JobRunning <$> (fields .: "status") <*> (fields .: "metadata") <*> (fields .: "params") <*> (fields .: "startedAt") <*> (fields .: "progress"))

instance ToJSON JobRunning where toJSON value = Object (KM.fromList (concat [[("status", toJSON (jobRunningStatus value))], [("metadata", toJSON (jobRunningMetadata value))], [("params", toJSON (jobRunningParams value))], [("startedAt", toJSON (jobRunningStartedAt value))], [("progress", toJSON (jobRunningProgress value))]]))

data JobRunningStatus = JobRunningStatusRunning deriving (Eq, Show)

instance FromJSON JobRunningStatus where parseJSON = checked "JobRunningStatus" $ \value -> if value == String "running" then pure JobRunningStatusRunning else fail "unknown enumeration member"

instance ToJSON JobRunningStatus where toJSON JobRunningStatusRunning = String "running"

jobRunningStatusText :: JobRunningStatus -> Text
jobRunningStatusText JobRunningStatusRunning = "running"
