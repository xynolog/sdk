-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressGeneratingResource (JobProgressGeneratingResource (..), JobProgressGeneratingResourceCode (..), jobProgressGeneratingResourceCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressGeneratingResource = JobProgressGeneratingResource
  { jobProgressGeneratingResourceCode :: JobProgressGeneratingResourceCode,
    jobProgressGeneratingResourceAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobProgressGeneratingResource where parseJSON = checked "JobProgressGeneratingResource" $ withObject "JobProgressGeneratingResource" (\fields -> JobProgressGeneratingResource <$> (fields .: "code") <*> traverse parseJSON (withoutFields ["code"] fields))

instance ToJSON JobProgressGeneratingResource where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressGeneratingResourceCode value))]]) <> fmap toJSON (withoutFields ["code"] (jobProgressGeneratingResourceAdditionalProperties value)))

data JobProgressGeneratingResourceCode = JobProgressGeneratingResourceCodeGeneratingU2d_resource deriving (Eq, Show)

instance FromJSON JobProgressGeneratingResourceCode where parseJSON = checked "JobProgressGeneratingResourceCode" $ \value -> if value == String "generating-resource" then pure JobProgressGeneratingResourceCodeGeneratingU2d_resource else fail "unknown enumeration member"

instance ToJSON JobProgressGeneratingResourceCode where toJSON JobProgressGeneratingResourceCodeGeneratingU2d_resource = String "generating-resource"

jobProgressGeneratingResourceCodeText :: JobProgressGeneratingResourceCode -> Text
jobProgressGeneratingResourceCodeText JobProgressGeneratingResourceCodeGeneratingU2d_resource = "generating-resource"
