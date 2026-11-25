-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerEngineConfig (WorkerEngineConfig (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Engine
import Xynolog.Internal.Generated.Models.JobFilter

data WorkerEngineConfig = WorkerEngineConfig
  { workerEngineConfigEngine :: Engine,
    workerEngineConfigJobs :: [JobFilter],
    workerEngineConfigBaseUrl :: Text,
    workerEngineConfigApiKeyEnv :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerEngineConfig where parseJSON = checked "WorkerEngineConfig" $ withObject "WorkerEngineConfig" (\fields -> WorkerEngineConfig <$> (fields .: "engine") <*> (fields .: "jobs") <*> (fields .: "baseUrl") <*> optional fields "apiKeyEnv")

instance ToJSON WorkerEngineConfig where toJSON value = Object (KM.fromList (concat [[("engine", toJSON (workerEngineConfigEngine value))], [("jobs", toJSON (workerEngineConfigJobs value))], [("baseUrl", toJSON (workerEngineConfigBaseUrl value))], optionalPair "apiKeyEnv" (workerEngineConfigApiKeyEnv value)]))
