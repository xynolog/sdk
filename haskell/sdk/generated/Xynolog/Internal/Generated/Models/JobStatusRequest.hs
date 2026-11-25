-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobStatusRequest (JobStatusRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobId

data JobStatusRequest = JobStatusRequest
  { jobStatusRequestJobId :: JobId
  }
  deriving (Eq, Show)

instance FromJSON JobStatusRequest where parseJSON = checked "JobStatusRequest" $ withObject "JobStatusRequest" (\fields -> JobStatusRequest <$> (fields .: "jobId"))

instance ToJSON JobStatusRequest where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (jobStatusRequestJobId value))]]))
