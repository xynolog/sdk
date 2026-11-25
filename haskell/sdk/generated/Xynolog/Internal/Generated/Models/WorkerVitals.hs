-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerVitals (WorkerVitals (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.WorkerActiveJob

data WorkerVitals = WorkerVitals
  { workerVitalsLastQueuedEventAt :: Maybe Text,
    workerVitalsLastClaimAt :: Maybe Text,
    workerVitalsLastFinishedAt :: Maybe Text,
    workerVitalsLastActivityAt :: Maybe Text,
    workerVitalsActiveJob :: Maybe WorkerActiveJob,
    workerVitalsJobsCompleted :: Integer
  }
  deriving (Eq, Show)

instance FromJSON WorkerVitals where parseJSON = checked "WorkerVitals" $ withObject "WorkerVitals" (\fields -> WorkerVitals <$> (fields .: "lastQueuedEventAt") <*> (fields .: "lastClaimAt") <*> (fields .: "lastFinishedAt") <*> (fields .: "lastActivityAt") <*> (fields .: "activeJob") <*> (fields .: "jobsCompleted"))

instance ToJSON WorkerVitals where toJSON value = Object (KM.fromList (concat [[("lastQueuedEventAt", toJSON (workerVitalsLastQueuedEventAt value))], [("lastClaimAt", toJSON (workerVitalsLastClaimAt value))], [("lastFinishedAt", toJSON (workerVitalsLastFinishedAt value))], [("lastActivityAt", toJSON (workerVitalsLastActivityAt value))], [("activeJob", toJSON (workerVitalsActiveJob value))], [("jobsCompleted", toJSON (workerVitalsJobsCompleted value))]]))
