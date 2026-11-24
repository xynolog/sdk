-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerHealth (WorkerHealth (..), WorkerHealthStatus (..), workerHealthStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.WorkerKnowledgeBaseHealth

data WorkerHealth = WorkerHealth
  { workerHealthKnowledgeBases :: [WorkerKnowledgeBaseHealth],
    workerHealthStatus :: WorkerHealthStatus
  }
  deriving (Eq, Show)

instance FromJSON WorkerHealth where parseJSON = checked "WorkerHealth" $ withObject "WorkerHealth" (\fields -> WorkerHealth <$> (fields .: "knowledgeBases") <*> (fields .: "status"))

instance ToJSON WorkerHealth where toJSON value = Object (KM.fromList (concat [[("knowledgeBases", toJSON (workerHealthKnowledgeBases value))], [("status", toJSON (workerHealthStatus value))]]))

data WorkerHealthStatus = WorkerHealthStatusOk deriving (Eq, Show)

instance FromJSON WorkerHealthStatus where parseJSON = checked "WorkerHealthStatus" $ \value -> if value == String "ok" then pure WorkerHealthStatusOk else fail "unknown enumeration member"

instance ToJSON WorkerHealthStatus where toJSON WorkerHealthStatusOk = String "ok"

workerHealthStatusText :: WorkerHealthStatus -> Text
workerHealthStatusText WorkerHealthStatusOk = "ok"
