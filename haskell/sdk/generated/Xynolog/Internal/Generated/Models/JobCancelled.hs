-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobCancelled (JobCancelled (..), JobCancelledStatus (..), jobCancelledStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobMetadata
import Xynolog.Internal.Generated.Models.JobParams

data JobCancelled = JobCancelled
  { jobCancelledStatus :: JobCancelledStatus,
    jobCancelledMetadata :: JobMetadata,
    jobCancelledParams :: JobParams,
    jobCancelledStartedAt :: Maybe Text,
    jobCancelledCompletedAt :: Text
  }
  deriving (Eq, Show)

instance FromJSON JobCancelled where parseJSON = checked "JobCancelled" $ withObject "JobCancelled" (\fields -> JobCancelled <$> (fields .: "status") <*> (fields .: "metadata") <*> (fields .: "params") <*> optional fields "startedAt" <*> (fields .: "completedAt"))

instance ToJSON JobCancelled where toJSON value = Object (KM.fromList (concat [[("status", toJSON (jobCancelledStatus value))], [("metadata", toJSON (jobCancelledMetadata value))], [("params", toJSON (jobCancelledParams value))], optionalPair "startedAt" (jobCancelledStartedAt value), [("completedAt", toJSON (jobCancelledCompletedAt value))]]))

data JobCancelledStatus = JobCancelledStatusCancelled deriving (Eq, Show)

instance FromJSON JobCancelledStatus where parseJSON = checked "JobCancelledStatus" $ \value -> if value == String "cancelled" then pure JobCancelledStatusCancelled else fail "unknown enumeration member"

instance ToJSON JobCancelledStatus where toJSON JobCancelledStatusCancelled = String "cancelled"

jobCancelledStatusText :: JobCancelledStatus -> Text
jobCancelledStatusText JobCancelledStatusCancelled = "cancelled"
