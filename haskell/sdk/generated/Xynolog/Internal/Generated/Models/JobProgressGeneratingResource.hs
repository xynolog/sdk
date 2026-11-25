-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressGeneratingResource (JobProgressGeneratingResource (..), JobProgressGeneratingResourceCode (..), jobProgressGeneratingResourceCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressGeneratingResource = JobProgressGeneratingResource
  { jobProgressGeneratingResourceCode :: JobProgressGeneratingResourceCode
  }
  deriving (Eq, Show)

instance FromJSON JobProgressGeneratingResource where parseJSON = checked "JobProgressGeneratingResource" $ withObject "JobProgressGeneratingResource" (\fields -> JobProgressGeneratingResource <$> (fields .: "code"))

instance ToJSON JobProgressGeneratingResource where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressGeneratingResourceCode value))]]))

data JobProgressGeneratingResourceCode = JobProgressGeneratingResourceCodeGeneratingResource deriving (Eq, Show)

instance FromJSON JobProgressGeneratingResourceCode where parseJSON = checked "JobProgressGeneratingResourceCode" $ \value -> if value == String "generating-resource" then pure JobProgressGeneratingResourceCodeGeneratingResource else fail "unknown enumeration member"

instance ToJSON JobProgressGeneratingResourceCode where toJSON JobProgressGeneratingResourceCodeGeneratingResource = String "generating-resource"

jobProgressGeneratingResourceCodeText :: JobProgressGeneratingResourceCode -> Text
jobProgressGeneratingResourceCodeText JobProgressGeneratingResourceCodeGeneratingResource = "generating-resource"
