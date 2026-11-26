-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobCompleteCommand (JobCompleteCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MarkJobCompleteCommand
import Xynolog.Internal.Generated.Models.YieldJobCompleteCommand

data JobCompleteCommand = JobCompleteCommandMarkJobCompleteCommand MarkJobCompleteCommand | JobCompleteCommandYieldJobCompleteCommand YieldJobCompleteCommand deriving (Eq, Show)

instance FromJSON JobCompleteCommand where parseJSON = checked "JobCompleteCommand" $ \value -> readMember "JobCompleteCommand" [([Signature {signatureKind = ObjectKind, signatureRequired = ["resourceId", "jobId", "jobType"], signatureAllowed = Nothing, signatureFixed = [("jobType", [String "mark"]), ("durability", [String "acknowledged", String "probe-confirmed", String "probe-refused", String "probe-unreachable"])], signaturePattern = Nothing, signatureValues = Nothing}], JobCompleteCommandMarkJobCompleteCommand <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["resourceId", "jobId", "jobType"], signatureAllowed = Nothing, signatureFixed = [("jobType", [String "yield"]), ("durability", [String "acknowledged", String "probe-confirmed", String "probe-refused", String "probe-unreachable"])], signaturePattern = Nothing, signatureValues = Nothing}], JobCompleteCommandYieldJobCompleteCommand <$> parseJSON value)] value

instance ToJSON JobCompleteCommand where
  toJSON (JobCompleteCommandMarkJobCompleteCommand value) = toJSON value
  toJSON (JobCompleteCommandYieldJobCompleteCommand value) = toJSON value
