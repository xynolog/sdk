-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerEngineHealth (WorkerEngineHealth (..), WorkerEngineHealthActiveJob (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Engine
import Xynolog.Internal.Generated.Models.JobFilter
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType

data WorkerEngineHealth = WorkerEngineHealth
  { workerEngineHealthEngine :: Engine,
    workerEngineHealthJobs :: [JobFilter],
    workerEngineHealthLastQueuedEventAt :: Maybe Text,
    workerEngineHealthLastClaimAt :: Maybe Text,
    workerEngineHealthLastFinishedAt :: Maybe Text,
    workerEngineHealthLastActivityAt :: Maybe Text,
    workerEngineHealthActiveJob :: Maybe WorkerEngineHealthActiveJob,
    workerEngineHealthJobsCompleted :: Integer
  }
  deriving (Eq, Show)

instance FromJSON WorkerEngineHealth where parseJSON = checked "WorkerEngineHealth" $ withObject "WorkerEngineHealth" (\fields -> WorkerEngineHealth <$> (fields .: "engine") <*> (fields .: "jobs") <*> (fields .: "lastQueuedEventAt") <*> (fields .: "lastClaimAt") <*> (fields .: "lastFinishedAt") <*> (fields .: "lastActivityAt") <*> (fields .: "activeJob") <*> (fields .: "jobsCompleted"))

instance ToJSON WorkerEngineHealth where toJSON value = Object (KM.fromList (concat [[("engine", toJSON (workerEngineHealthEngine value))], [("jobs", toJSON (workerEngineHealthJobs value))], [("lastQueuedEventAt", toJSON (workerEngineHealthLastQueuedEventAt value))], [("lastClaimAt", toJSON (workerEngineHealthLastClaimAt value))], [("lastFinishedAt", toJSON (workerEngineHealthLastFinishedAt value))], [("lastActivityAt", toJSON (workerEngineHealthLastActivityAt value))], [("activeJob", toJSON (workerEngineHealthActiveJob value))], [("jobsCompleted", toJSON (workerEngineHealthJobsCompleted value))]]))

data WorkerEngineHealthActiveJob = WorkerEngineHealthActiveJob
  { workerEngineHealthActiveJobJobId :: JobId,
    workerEngineHealthActiveJobType :: JobType,
    workerEngineHealthActiveJobSince :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerEngineHealthActiveJob where parseJSON = checked "WorkerEngineHealthActiveJob" $ withObject "WorkerEngineHealthActiveJob" (\fields -> WorkerEngineHealthActiveJob <$> (fields .: "jobId") <*> (fields .: "type") <*> (fields .: "since"))

instance ToJSON WorkerEngineHealthActiveJob where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (workerEngineHealthActiveJobJobId value))], [("type", toJSON (workerEngineHealthActiveJobType value))], [("since", toJSON (workerEngineHealthActiveJobSince value))]]))
