-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobFilter (JobFilter (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MarkJobFilter
import Xynolog.Internal.Generated.Models.YieldJobFilter

data JobFilter = JobFilterMarkJobFilter MarkJobFilter | JobFilterYieldJobFilter YieldJobFilter deriving (Eq, Show)

instance FromJSON JobFilter where parseJSON = checked "JobFilter" $ \value -> readMember "JobFilter" [([Signature {signatureKind = ObjectKind, signatureRequired = ["jobType", "params"], signatureAllowed = Just ["jobType", "params"], signatureFixed = [("jobType", [String "mark"])], signaturePattern = Nothing, signatureValues = Nothing}], JobFilterMarkJobFilter <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["jobType"], signatureAllowed = Just ["jobType"], signatureFixed = [("jobType", [String "yield"])], signaturePattern = Nothing, signatureValues = Nothing}], JobFilterYieldJobFilter <$> parseJSON value)] value

instance ToJSON JobFilter where
  toJSON (JobFilterMarkJobFilter value) = toJSON value
  toJSON (JobFilterYieldJobFilter value) = toJSON value
