-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressCreatingResource (JobProgressCreatingResource (..), JobProgressCreatingResourceCode (..), jobProgressCreatingResourceCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressCreatingResource = JobProgressCreatingResource
  { jobProgressCreatingResourceCode :: JobProgressCreatingResourceCode,
    jobProgressCreatingResourceAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCreatingResource where parseJSON = checked "JobProgressCreatingResource" $ withObject "JobProgressCreatingResource" (\fields -> JobProgressCreatingResource <$> (fields .: "code") <*> traverse parseJSON (withoutFields ["code"] fields))

instance ToJSON JobProgressCreatingResource where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressCreatingResourceCode value))]]) <> fmap toJSON (withoutFields ["code"] (jobProgressCreatingResourceAdditionalProperties value)))

data JobProgressCreatingResourceCode = JobProgressCreatingResourceCodeCreatingU2d_resource deriving (Eq, Show)

instance FromJSON JobProgressCreatingResourceCode where parseJSON = checked "JobProgressCreatingResourceCode" $ \value -> if value == String "creating-resource" then pure JobProgressCreatingResourceCodeCreatingU2d_resource else fail "unknown enumeration member"

instance ToJSON JobProgressCreatingResourceCode where toJSON JobProgressCreatingResourceCodeCreatingU2d_resource = String "creating-resource"

jobProgressCreatingResourceCodeText :: JobProgressCreatingResourceCode -> Text
jobProgressCreatingResourceCodeText JobProgressCreatingResourceCodeCreatingU2d_resource = "creating-resource"
