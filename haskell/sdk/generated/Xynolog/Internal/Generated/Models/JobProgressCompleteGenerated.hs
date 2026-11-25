-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressCompleteGenerated (JobProgressCompleteGenerated (..), JobProgressCompleteGeneratedCode (..), jobProgressCompleteGeneratedCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressCompleteGenerated = JobProgressCompleteGenerated
  { jobProgressCompleteGeneratedCode :: JobProgressCompleteGeneratedCode,
    jobProgressCompleteGeneratedTruncated :: Bool
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCompleteGenerated where parseJSON = checked "JobProgressCompleteGenerated" $ withObject "JobProgressCompleteGenerated" (\fields -> JobProgressCompleteGenerated <$> (fields .: "code") <*> (fields .: "truncated"))

instance ToJSON JobProgressCompleteGenerated where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressCompleteGeneratedCode value))], [("truncated", toJSON (jobProgressCompleteGeneratedTruncated value))]]))

data JobProgressCompleteGeneratedCode = JobProgressCompleteGeneratedCodeCompleteGenerated deriving (Eq, Show)

instance FromJSON JobProgressCompleteGeneratedCode where parseJSON = checked "JobProgressCompleteGeneratedCode" $ \value -> if value == String "complete-generated" then pure JobProgressCompleteGeneratedCodeCompleteGenerated else fail "unknown enumeration member"

instance ToJSON JobProgressCompleteGeneratedCode where toJSON JobProgressCompleteGeneratedCodeCompleteGenerated = String "complete-generated"

jobProgressCompleteGeneratedCodeText :: JobProgressCompleteGeneratedCode -> Text
jobProgressCompleteGeneratedCodeText JobProgressCompleteGeneratedCodeCompleteGenerated = "complete-generated"
