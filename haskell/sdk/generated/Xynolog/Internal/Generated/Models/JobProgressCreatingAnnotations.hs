-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressCreatingAnnotations (JobProgressCreatingAnnotations (..), JobProgressCreatingAnnotationsCode (..), jobProgressCreatingAnnotationsCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressCreatingAnnotations = JobProgressCreatingAnnotations
  { jobProgressCreatingAnnotationsCode :: JobProgressCreatingAnnotationsCode,
    jobProgressCreatingAnnotationsCount :: Integer,
    jobProgressCreatingAnnotationsAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCreatingAnnotations where parseJSON = checked "JobProgressCreatingAnnotations" $ withObject "JobProgressCreatingAnnotations" (\fields -> JobProgressCreatingAnnotations <$> (fields .: "code") <*> (fields .: "count") <*> traverse parseJSON (withoutFields ["code", "count"] fields))

instance ToJSON JobProgressCreatingAnnotations where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressCreatingAnnotationsCode value))], [("count", toJSON (jobProgressCreatingAnnotationsCount value))]]) <> fmap toJSON (withoutFields ["code", "count"] (jobProgressCreatingAnnotationsAdditionalProperties value)))

data JobProgressCreatingAnnotationsCode = JobProgressCreatingAnnotationsCodeCreatingAnnotations deriving (Eq, Show)

instance FromJSON JobProgressCreatingAnnotationsCode where parseJSON = checked "JobProgressCreatingAnnotationsCode" $ \value -> if value == String "creating-annotations" then pure JobProgressCreatingAnnotationsCodeCreatingAnnotations else fail "unknown enumeration member"

instance ToJSON JobProgressCreatingAnnotationsCode where toJSON JobProgressCreatingAnnotationsCodeCreatingAnnotations = String "creating-annotations"

jobProgressCreatingAnnotationsCodeText :: JobProgressCreatingAnnotationsCode -> Text
jobProgressCreatingAnnotationsCodeText JobProgressCreatingAnnotationsCodeCreatingAnnotations = "creating-annotations"
