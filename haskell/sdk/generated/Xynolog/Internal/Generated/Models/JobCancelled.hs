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
  { jobCancelledCompletedAt :: Text,
    jobCancelledMetadata :: JobMetadata,
    jobCancelledParams :: JobParams,
    jobCancelledStartedAt :: Maybe Text,
    jobCancelledStatus :: JobCancelledStatus
  }
  deriving (Eq, Show)

instance FromJSON JobCancelled where parseJSON = checked "JobCancelled" $ withObject "JobCancelled" (\fields -> JobCancelled <$> (fields .: "completedAt") <*> (fields .: "metadata") <*> (fields .: "params") <*> optional fields "startedAt" <*> (fields .: "status"))

instance ToJSON JobCancelled where toJSON value = Object (KM.fromList (concat [[("completedAt", toJSON (jobCancelledCompletedAt value))], [("metadata", toJSON (jobCancelledMetadata value))], [("params", toJSON (jobCancelledParams value))], optionalPair "startedAt" (jobCancelledStartedAt value), [("status", toJSON (jobCancelledStatus value))]]))

data JobCancelledStatus = JobCancelledStatusCancelled deriving (Eq, Show)

instance FromJSON JobCancelledStatus where parseJSON = checked "JobCancelledStatus" $ \value -> if value == String "cancelled" then pure JobCancelledStatusCancelled else fail "unknown enumeration member"

instance ToJSON JobCancelledStatus where toJSON JobCancelledStatusCancelled = String "cancelled"

jobCancelledStatusText :: JobCancelledStatus -> Text
jobCancelledStatusText JobCancelledStatusCancelled = "cancelled"
