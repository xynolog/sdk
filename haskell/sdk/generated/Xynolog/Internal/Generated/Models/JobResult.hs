-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobResult (JobResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobDeclined
import Xynolog.Internal.Generated.Models.MarkJobDone
import Xynolog.Internal.Generated.Models.YieldJobDone

data JobResult = JobResultMarkJobDone MarkJobDone | JobResultYieldJobDone YieldJobDone | JobResultJobDeclined JobDeclined deriving (Eq, Show)

instance FromJSON JobResult where parseJSON = checked "JobResult" $ \value -> readMember "JobResult" [([Signature {signatureKind = ObjectKind, signatureRequired = ["found", "persisted"], signatureAllowed = Just ["found", "persisted", "errors", "byCategory", "underReportedPieces", "uncheckedPieces"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], JobResultMarkJobDone <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["resourceId", "resourceName", "truncated"], signatureAllowed = Just ["resourceId", "resourceName", "truncated"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], JobResultYieldJobDone <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["declined", "reason"], signatureAllowed = Just ["declined", "reason"], signatureFixed = [("declined", [Bool True]), ("reason", [String "no-text-layer", String "encrypted", String "corrupt", String "too-large", String "empty"])], signaturePattern = Nothing, signatureValues = Nothing}], JobResultJobDeclined <$> parseJSON value)] value

instance ToJSON JobResult where
  toJSON (JobResultMarkJobDone value) = toJSON value
  toJSON (JobResultYieldJobDone value) = toJSON value
  toJSON (JobResultJobDeclined value) = toJSON value
