-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressAnalyzing (JobProgressAnalyzing (..), JobProgressAnalyzingCode (..), jobProgressAnalyzingCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressAnalyzing = JobProgressAnalyzing
  { jobProgressAnalyzingCode :: JobProgressAnalyzingCode
  }
  deriving (Eq, Show)

instance FromJSON JobProgressAnalyzing where parseJSON = checked "JobProgressAnalyzing" $ withObject "JobProgressAnalyzing" (\fields -> JobProgressAnalyzing <$> (fields .: "code"))

instance ToJSON JobProgressAnalyzing where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressAnalyzingCode value))]]))

data JobProgressAnalyzingCode = JobProgressAnalyzingCodeAnalyzing deriving (Eq, Show)

instance FromJSON JobProgressAnalyzingCode where parseJSON = checked "JobProgressAnalyzingCode" $ \value -> if value == String "analyzing" then pure JobProgressAnalyzingCodeAnalyzing else fail "unknown enumeration member"

instance ToJSON JobProgressAnalyzingCode where toJSON JobProgressAnalyzingCodeAnalyzing = String "analyzing"

jobProgressAnalyzingCodeText :: JobProgressAnalyzingCode -> Text
jobProgressAnalyzingCodeText JobProgressAnalyzingCodeAnalyzing = "analyzing"
