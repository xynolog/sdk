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
  { jobCompleteCompletedAt :: Text,
    jobCompleteMetadata :: JobMetadata,
    jobCompleteParams :: JobParams,
    jobCompleteResult :: JobStoredResult,
    jobCompleteStartedAt :: Text,
    jobCompleteStatus :: JobCompleteStatus
  }
  deriving (Eq, Show)

instance FromJSON JobComplete where parseJSON = checked "JobComplete" $ withObject "JobComplete" (\fields -> JobComplete <$> (fields .: "completedAt") <*> (fields .: "metadata") <*> (fields .: "params") <*> (fields .: "result") <*> (fields .: "startedAt") <*> (fields .: "status"))

instance ToJSON JobComplete where toJSON value = Object (KM.fromList (concat [[("completedAt", toJSON (jobCompleteCompletedAt value))], [("metadata", toJSON (jobCompleteMetadata value))], [("params", toJSON (jobCompleteParams value))], [("result", toJSON (jobCompleteResult value))], [("startedAt", toJSON (jobCompleteStartedAt value))], [("status", toJSON (jobCompleteStatus value))]]))

data JobCompleteStatus = JobCompleteStatusComplete deriving (Eq, Show)

instance FromJSON JobCompleteStatus where parseJSON = checked "JobCompleteStatus" $ \value -> if value == String "complete" then pure JobCompleteStatusComplete else fail "unknown enumeration member"

instance ToJSON JobCompleteStatus where toJSON JobCompleteStatusComplete = String "complete"

jobCompleteStatusText :: JobCompleteStatus -> Text
jobCompleteStatusText JobCompleteStatusComplete = "complete"
