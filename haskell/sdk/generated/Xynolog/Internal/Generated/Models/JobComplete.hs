-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobComplete (JobComplete (..), JobCompleteStatus (..), jobCompleteStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobMetadata
import Xynolog.Internal.Generated.Models.JobParams
import Xynolog.Internal.Generated.Models.JobStoredResult

data JobComplete = JobComplete
  { jobCompleteStatus :: JobCompleteStatus,
    jobCompleteMetadata :: JobMetadata,
    jobCompleteParams :: JobParams,
    jobCompleteStartedAt :: Text,
    jobCompleteCompletedAt :: Text,
    jobCompleteResult :: JobStoredResult
  }
  deriving (Eq, Show)

instance FromJSON JobComplete where parseJSON = checked "JobComplete" $ withObject "JobComplete" (\fields -> JobComplete <$> (fields .: "status") <*> (fields .: "metadata") <*> (fields .: "params") <*> (fields .: "startedAt") <*> (fields .: "completedAt") <*> (fields .: "result"))

instance ToJSON JobComplete where toJSON value = Object (KM.fromList (concat [[("status", toJSON (jobCompleteStatus value))], [("metadata", toJSON (jobCompleteMetadata value))], [("params", toJSON (jobCompleteParams value))], [("startedAt", toJSON (jobCompleteStartedAt value))], [("completedAt", toJSON (jobCompleteCompletedAt value))], [("result", toJSON (jobCompleteResult value))]]))

data JobCompleteStatus = JobCompleteStatusComplete deriving (Eq, Show)

instance FromJSON JobCompleteStatus where parseJSON = checked "JobCompleteStatus" $ \value -> if value == String "complete" then pure JobCompleteStatusComplete else fail "unknown enumeration member"

instance ToJSON JobCompleteStatus where toJSON JobCompleteStatusComplete = String "complete"

jobCompleteStatusText :: JobCompleteStatus -> Text
jobCompleteStatusText JobCompleteStatusComplete = "complete"
