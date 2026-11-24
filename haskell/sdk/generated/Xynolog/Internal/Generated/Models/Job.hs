-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Job (Job (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobCancelled
import Xynolog.Internal.Generated.Models.JobComplete
import Xynolog.Internal.Generated.Models.JobFailed
import Xynolog.Internal.Generated.Models.JobPending
import Xynolog.Internal.Generated.Models.JobRunning

data Job = JobJobPending JobPending | JobJobRunning JobRunning | JobJobComplete JobComplete | JobJobFailed JobFailed | JobJobCancelled JobCancelled deriving (Eq, Show)

instance FromJSON Job where parseJSON = checked "Job" $ \value -> (JobJobPending <$> parseJSON value) <|> (JobJobRunning <$> parseJSON value) <|> (JobJobComplete <$> parseJSON value) <|> (JobJobFailed <$> parseJSON value) <|> (JobJobCancelled <$> parseJSON value)

instance ToJSON Job where
  toJSON (JobJobPending value) = toJSON value
  toJSON (JobJobRunning value) = toJSON value
  toJSON (JobJobComplete value) = toJSON value
  toJSON (JobJobFailed value) = toJSON value
  toJSON (JobJobCancelled value) = toJSON value
