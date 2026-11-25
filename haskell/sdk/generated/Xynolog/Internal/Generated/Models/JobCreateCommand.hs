-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobCreateCommand (JobCreateCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MarkJobCreateCommand
import Xynolog.Internal.Generated.Models.YieldJobCreateCommand

data JobCreateCommand = JobCreateCommandMarkJobCreateCommand MarkJobCreateCommand | JobCreateCommandYieldJobCreateCommand YieldJobCreateCommand deriving (Eq, Show)

instance FromJSON JobCreateCommand where parseJSON = checked "JobCreateCommand" $ \value -> readMember "JobCreateCommand" [([Signature {signatureKind = ObjectKind, signatureRequired = ["jobType", "resourceId", "params"], signatureAllowed = Just ["_userId", "_roles", "jobType", "resourceId", "params"], signatureFixed = [("jobType", [String "mark"])], signaturePattern = Nothing, signatureValues = Nothing}], JobCreateCommandMarkJobCreateCommand <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["jobType", "params"], signatureAllowed = Just ["_userId", "_roles", "jobType", "params"], signatureFixed = [("jobType", [String "yield"])], signaturePattern = Nothing, signatureValues = Nothing}], JobCreateCommandYieldJobCreateCommand <$> parseJSON value)] value

instance ToJSON JobCreateCommand where
  toJSON (JobCreateCommandMarkJobCreateCommand value) = toJSON value
  toJSON (JobCreateCommandYieldJobCreateCommand value) = toJSON value
