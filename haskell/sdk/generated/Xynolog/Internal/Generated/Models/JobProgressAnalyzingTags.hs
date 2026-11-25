-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressAnalyzingTags (JobProgressAnalyzingTags (..), JobProgressAnalyzingTagsCode (..), jobProgressAnalyzingTagsCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressAnalyzingTags = JobProgressAnalyzingTags
  { jobProgressAnalyzingTagsCode :: JobProgressAnalyzingTagsCode,
    jobProgressAnalyzingTagsAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobProgressAnalyzingTags where parseJSON = checked "JobProgressAnalyzingTags" $ withObject "JobProgressAnalyzingTags" (\fields -> JobProgressAnalyzingTags <$> (fields .: "code") <*> traverse parseJSON (withoutFields ["code"] fields))

instance ToJSON JobProgressAnalyzingTags where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressAnalyzingTagsCode value))]]) <> fmap toJSON (withoutFields ["code"] (jobProgressAnalyzingTagsAdditionalProperties value)))

data JobProgressAnalyzingTagsCode = JobProgressAnalyzingTagsCodeAnalyzingTags deriving (Eq, Show)

instance FromJSON JobProgressAnalyzingTagsCode where parseJSON = checked "JobProgressAnalyzingTagsCode" $ \value -> if value == String "analyzing-tags" then pure JobProgressAnalyzingTagsCodeAnalyzingTags else fail "unknown enumeration member"

instance ToJSON JobProgressAnalyzingTagsCode where toJSON JobProgressAnalyzingTagsCodeAnalyzingTags = String "analyzing-tags"

jobProgressAnalyzingTagsCodeText :: JobProgressAnalyzingTagsCode -> Text
jobProgressAnalyzingTagsCodeText JobProgressAnalyzingTagsCodeAnalyzingTags = "analyzing-tags"
