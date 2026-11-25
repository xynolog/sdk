-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobQueuedEvent (JobQueuedEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MarkJobQueuedEvent
import Xynolog.Internal.Generated.Models.YieldJobQueuedEvent

data JobQueuedEvent = JobQueuedEventMarkJobQueuedEvent MarkJobQueuedEvent | JobQueuedEventYieldJobQueuedEvent YieldJobQueuedEvent deriving (Eq, Show)

instance FromJSON JobQueuedEvent where parseJSON = checked "JobQueuedEvent" $ \value -> readMember "JobQueuedEvent" [([Signature {signatureKind = ObjectKind, signatureRequired = ["jobId", "jobType", "resourceId", "userId", "params"], signatureAllowed = Nothing, signatureFixed = [("jobType", [String "mark"])], signaturePattern = Nothing, signatureValues = Nothing}], JobQueuedEventMarkJobQueuedEvent <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["jobId", "jobType", "resourceId", "userId", "params"], signatureAllowed = Nothing, signatureFixed = [("jobType", [String "yield"])], signaturePattern = Nothing, signatureValues = Nothing}], JobQueuedEventYieldJobQueuedEvent <$> parseJSON value)] value

instance ToJSON JobQueuedEvent where
  toJSON (JobQueuedEventMarkJobQueuedEvent value) = toJSON value
  toJSON (JobQueuedEventYieldJobQueuedEvent value) = toJSON value
