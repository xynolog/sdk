-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobCancelRequest (JobCancelRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobId

data JobCancelRequest = JobCancelRequest
  { jobCancelRequestJobId :: JobId
  }
  deriving (Eq, Show)

instance FromJSON JobCancelRequest where parseJSON = checked "JobCancelRequest" $ withObject "JobCancelRequest" (\fields -> JobCancelRequest <$> (fields .: "jobId"))

instance ToJSON JobCancelRequest where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (jobCancelRequestJobId value))]]))
