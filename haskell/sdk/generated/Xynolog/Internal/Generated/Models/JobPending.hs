-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobPending (JobPending (..), JobPendingStatus (..), jobPendingStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobMetadata
import Xynolog.Internal.Generated.Models.JobParams

data JobPending = JobPending
  { jobPendingStatus :: JobPendingStatus,
    jobPendingMetadata :: JobMetadata,
    jobPendingParams :: JobParams
  }
  deriving (Eq, Show)

instance FromJSON JobPending where parseJSON = checked "JobPending" $ withObject "JobPending" (\fields -> JobPending <$> (fields .: "status") <*> (fields .: "metadata") <*> (fields .: "params"))

instance ToJSON JobPending where toJSON value = Object (KM.fromList (concat [[("status", toJSON (jobPendingStatus value))], [("metadata", toJSON (jobPendingMetadata value))], [("params", toJSON (jobPendingParams value))]]))

data JobPendingStatus = JobPendingStatusPending deriving (Eq, Show)

instance FromJSON JobPendingStatus where parseJSON = checked "JobPendingStatus" $ \value -> if value == String "pending" then pure JobPendingStatusPending else fail "unknown enumeration member"

instance ToJSON JobPendingStatus where toJSON JobPendingStatusPending = String "pending"

jobPendingStatusText :: JobPendingStatus -> Text
jobPendingStatusText JobPendingStatusPending = "pending"
