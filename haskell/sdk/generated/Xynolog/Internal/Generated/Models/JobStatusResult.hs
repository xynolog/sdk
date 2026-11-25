-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobStatusResult (JobStatusResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobStatusResponse

data JobStatusResult = JobStatusResult
  { jobStatusResultResponse :: JobStatusResponse
  }
  deriving (Eq, Show)

instance FromJSON JobStatusResult where parseJSON = checked "JobStatusResult" $ withObject "JobStatusResult" (\fields -> JobStatusResult <$> (fields .: "response"))

instance ToJSON JobStatusResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (jobStatusResultResponse value))]]))
