-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressDetectingEntities (JobProgressDetectingEntities (..), JobProgressDetectingEntitiesCode (..), jobProgressDetectingEntitiesCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressDetectingEntities = JobProgressDetectingEntities
  { jobProgressDetectingEntitiesCode :: JobProgressDetectingEntitiesCode,
    jobProgressDetectingEntitiesEntityType :: Text
  }
  deriving (Eq, Show)

instance FromJSON JobProgressDetectingEntities where parseJSON = checked "JobProgressDetectingEntities" $ withObject "JobProgressDetectingEntities" (\fields -> JobProgressDetectingEntities <$> (fields .: "code") <*> (fields .: "entityType"))

instance ToJSON JobProgressDetectingEntities where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressDetectingEntitiesCode value))], [("entityType", toJSON (jobProgressDetectingEntitiesEntityType value))]]))

data JobProgressDetectingEntitiesCode = JobProgressDetectingEntitiesCodeDetectingEntities deriving (Eq, Show)

instance FromJSON JobProgressDetectingEntitiesCode where parseJSON = checked "JobProgressDetectingEntitiesCode" $ \value -> if value == String "detecting-entities" then pure JobProgressDetectingEntitiesCodeDetectingEntities else fail "unknown enumeration member"

instance ToJSON JobProgressDetectingEntitiesCode where toJSON JobProgressDetectingEntitiesCodeDetectingEntities = String "detecting-entities"

jobProgressDetectingEntitiesCodeText :: JobProgressDetectingEntitiesCode -> Text
jobProgressDetectingEntitiesCodeText JobProgressDetectingEntitiesCodeDetectingEntities = "detecting-entities"
