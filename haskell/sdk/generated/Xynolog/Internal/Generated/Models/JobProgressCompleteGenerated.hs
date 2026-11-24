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
    jobProgressCompleteGeneratedTruncated :: Bool,
    jobProgressCompleteGeneratedAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCompleteGenerated where parseJSON = checked "JobProgressCompleteGenerated" $ withObject "JobProgressCompleteGenerated" (\fields -> JobProgressCompleteGenerated <$> (fields .: "code") <*> (fields .: "truncated") <*> traverse parseJSON (withoutFields ["code", "truncated"] fields))

instance ToJSON JobProgressCompleteGenerated where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressCompleteGeneratedCode value))], [("truncated", toJSON (jobProgressCompleteGeneratedTruncated value))]]) <> fmap toJSON (withoutFields ["code", "truncated"] (jobProgressCompleteGeneratedAdditionalProperties value)))

data JobProgressCompleteGeneratedCode = JobProgressCompleteGeneratedCodeCompleteU2d_generated deriving (Eq, Show)

instance FromJSON JobProgressCompleteGeneratedCode where parseJSON = checked "JobProgressCompleteGeneratedCode" $ \value -> if value == String "complete-generated" then pure JobProgressCompleteGeneratedCodeCompleteU2d_generated else fail "unknown enumeration member"

instance ToJSON JobProgressCompleteGeneratedCode where toJSON JobProgressCompleteGeneratedCodeCompleteU2d_generated = String "complete-generated"

jobProgressCompleteGeneratedCodeText :: JobProgressCompleteGeneratedCode -> Text
jobProgressCompleteGeneratedCodeText JobProgressCompleteGeneratedCodeCompleteU2d_generated = "complete-generated"
