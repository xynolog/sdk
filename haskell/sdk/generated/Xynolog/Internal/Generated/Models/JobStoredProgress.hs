-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobStoredProgress (JobStoredProgress (..), JobStoredProgressEmpty (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobProgress

data JobStoredProgress = JobStoredProgressJobProgress JobProgress | JobStoredProgressEmpty JobStoredProgressEmpty deriving (Eq, Show)

instance FromJSON JobStoredProgress where parseJSON = checked "JobStoredProgress" $ \value -> readMember "JobStoredProgress" [([Signature {signatureKind = ObjectKind, signatureRequired = ["percentage"], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], JobStoredProgressJobProgress <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = [], signatureAllowed = Just [], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], JobStoredProgressEmpty <$> parseJSON value)] value

instance ToJSON JobStoredProgress where
  toJSON (JobStoredProgressJobProgress value) = toJSON value
  toJSON (JobStoredProgressEmpty value) = toJSON value

data JobStoredProgressEmpty = MkJobStoredProgressEmpty
  { jobStoredProgressEmptyAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobStoredProgressEmpty where parseJSON = checked "JobStoredProgressEmpty" $ withObject "JobStoredProgressEmpty" (\fields -> MkJobStoredProgressEmpty <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobStoredProgressEmpty where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobStoredProgressEmptyAdditionalProperties value)))
