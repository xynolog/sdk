-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerActiveJob (WorkerActiveJob (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType

data WorkerActiveJob = WorkerActiveJob
  { workerActiveJobJobId :: JobId,
    workerActiveJobType :: JobType,
    workerActiveJobSince :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerActiveJob where parseJSON = checked "WorkerActiveJob" $ withObject "WorkerActiveJob" (\fields -> WorkerActiveJob <$> (fields .: "jobId") <*> (fields .: "type") <*> (fields .: "since"))

instance ToJSON WorkerActiveJob where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (workerActiveJobJobId value))], [("type", toJSON (workerActiveJobType value))], [("since", toJSON (workerActiveJobSince value))]]))
