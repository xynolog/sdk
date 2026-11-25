-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Job (Job (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobCancelled
import Xynolog.Internal.Generated.Models.JobComplete
import Xynolog.Internal.Generated.Models.JobFailed
import Xynolog.Internal.Generated.Models.JobPending
import Xynolog.Internal.Generated.Models.JobRunning

data Job = JobJobPending JobPending | JobJobRunning JobRunning | JobJobComplete JobComplete | JobJobFailed JobFailed | JobJobCancelled JobCancelled deriving (Eq, Show)

instance FromJSON Job where parseJSON = checked "Job" $ \value -> readMember "Job" [([Signature {signatureKind = ObjectKind, signatureRequired = ["status", "metadata", "params"], signatureAllowed = Just ["status", "metadata", "params"], signatureFixed = [("status", [String "pending"])], signaturePattern = Nothing, signatureValues = Nothing}], JobJobPending <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["status", "metadata", "params", "startedAt", "progress"], signatureAllowed = Just ["status", "metadata", "params", "startedAt", "progress"], signatureFixed = [("status", [String "running"])], signaturePattern = Nothing, signatureValues = Nothing}], JobJobRunning <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["status", "metadata", "params", "startedAt", "completedAt", "result"], signatureAllowed = Just ["status", "metadata", "params", "startedAt", "completedAt", "result"], signatureFixed = [("status", [String "complete"])], signaturePattern = Nothing, signatureValues = Nothing}], JobJobComplete <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["status", "metadata", "params", "completedAt", "error"], signatureAllowed = Just ["status", "metadata", "params", "startedAt", "completedAt", "error", "failureClass"], signatureFixed = [("status", [String "failed"]), ("failureClass", [String "transient", String "deterministic", String "withheld"])], signaturePattern = Nothing, signatureValues = Nothing}], JobJobFailed <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["status", "metadata", "params", "completedAt"], signatureAllowed = Just ["status", "metadata", "params", "startedAt", "completedAt"], signatureFixed = [("status", [String "cancelled"])], signaturePattern = Nothing, signatureValues = Nothing}], JobJobCancelled <$> parseJSON value)] value

instance ToJSON Job where
  toJSON (JobJobPending value) = toJSON value
  toJSON (JobJobRunning value) = toJSON value
  toJSON (JobJobComplete value) = toJSON value
  toJSON (JobJobFailed value) = toJSON value
  toJSON (JobJobCancelled value) = toJSON value
