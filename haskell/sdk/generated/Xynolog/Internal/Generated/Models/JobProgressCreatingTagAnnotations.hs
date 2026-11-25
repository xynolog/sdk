-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressCreatingTagAnnotations (JobProgressCreatingTagAnnotations (..), JobProgressCreatingTagAnnotationsCode (..), jobProgressCreatingTagAnnotationsCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressCreatingTagAnnotations = JobProgressCreatingTagAnnotations
  { jobProgressCreatingTagAnnotationsCode :: JobProgressCreatingTagAnnotationsCode,
    jobProgressCreatingTagAnnotationsCount :: Integer,
    jobProgressCreatingTagAnnotationsAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCreatingTagAnnotations where parseJSON = checked "JobProgressCreatingTagAnnotations" $ withObject "JobProgressCreatingTagAnnotations" (\fields -> JobProgressCreatingTagAnnotations <$> (fields .: "code") <*> (fields .: "count") <*> traverse parseJSON (withoutFields ["code", "count"] fields))

instance ToJSON JobProgressCreatingTagAnnotations where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressCreatingTagAnnotationsCode value))], [("count", toJSON (jobProgressCreatingTagAnnotationsCount value))]]) <> fmap toJSON (withoutFields ["code", "count"] (jobProgressCreatingTagAnnotationsAdditionalProperties value)))

data JobProgressCreatingTagAnnotationsCode = JobProgressCreatingTagAnnotationsCodeCreatingTagAnnotations deriving (Eq, Show)

instance FromJSON JobProgressCreatingTagAnnotationsCode where parseJSON = checked "JobProgressCreatingTagAnnotationsCode" $ \value -> if value == String "creating-tag-annotations" then pure JobProgressCreatingTagAnnotationsCodeCreatingTagAnnotations else fail "unknown enumeration member"

instance ToJSON JobProgressCreatingTagAnnotationsCode where toJSON JobProgressCreatingTagAnnotationsCodeCreatingTagAnnotations = String "creating-tag-annotations"

jobProgressCreatingTagAnnotationsCodeText :: JobProgressCreatingTagAnnotationsCode -> Text
jobProgressCreatingTagAnnotationsCodeText JobProgressCreatingTagAnnotationsCodeCreatingTagAnnotations = "creating-tag-annotations"
