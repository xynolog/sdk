-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobStoredResult (JobStoredResult (..), JobStoredResultEmpty (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobResult

data JobStoredResult = JobStoredResultJobResult JobResult | JobStoredResultEmpty JobStoredResultEmpty deriving (Eq, Show)

instance FromJSON JobStoredResult where parseJSON = checked "JobStoredResult" $ \value -> readMember "JobStoredResult" [([Signature {signatureKind = ObjectKind, signatureRequired = ["found", "persisted"], signatureAllowed = Just ["found", "persisted", "errors", "byCategory", "underReportedPieces", "uncheckedPieces"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}, Signature {signatureKind = ObjectKind, signatureRequired = ["resourceId", "resourceName", "truncated"], signatureAllowed = Just ["resourceId", "resourceName", "truncated"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}, Signature {signatureKind = ObjectKind, signatureRequired = ["declined", "reason"], signatureAllowed = Just ["declined", "reason"], signatureFixed = [("declined", [Bool True]), ("reason", [String "no-text-layer", String "encrypted", String "corrupt", String "too-large", String "empty"])], signaturePattern = Nothing, signatureValues = Nothing}], JobStoredResultJobResult <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = [], signatureAllowed = Just [], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], JobStoredResultEmpty <$> parseJSON value)] value

instance ToJSON JobStoredResult where
  toJSON (JobStoredResultJobResult value) = toJSON value
  toJSON (JobStoredResultEmpty value) = toJSON value

data JobStoredResultEmpty = MkJobStoredResultEmpty
  { jobStoredResultEmptyAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobStoredResultEmpty where parseJSON = checked "JobStoredResultEmpty" $ withObject "JobStoredResultEmpty" (\fields -> MkJobStoredResultEmpty <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobStoredResultEmpty where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobStoredResultEmptyAdditionalProperties value)))
