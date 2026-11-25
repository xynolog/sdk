-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressCreatingResource (JobProgressCreatingResource (..), JobProgressCreatingResourceCode (..), jobProgressCreatingResourceCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressCreatingResource = JobProgressCreatingResource
  { jobProgressCreatingResourceCode :: JobProgressCreatingResourceCode
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCreatingResource where parseJSON = checked "JobProgressCreatingResource" $ withObject "JobProgressCreatingResource" (\fields -> JobProgressCreatingResource <$> (fields .: "code"))

instance ToJSON JobProgressCreatingResource where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressCreatingResourceCode value))]]))

data JobProgressCreatingResourceCode = JobProgressCreatingResourceCodeCreatingResource deriving (Eq, Show)

instance FromJSON JobProgressCreatingResourceCode where parseJSON = checked "JobProgressCreatingResourceCode" $ \value -> if value == String "creating-resource" then pure JobProgressCreatingResourceCodeCreatingResource else fail "unknown enumeration member"

instance ToJSON JobProgressCreatingResourceCode where toJSON JobProgressCreatingResourceCodeCreatingResource = String "creating-resource"

jobProgressCreatingResourceCodeText :: JobProgressCreatingResourceCode -> Text
jobProgressCreatingResourceCodeText JobProgressCreatingResourceCodeCreatingResource = "creating-resource"
