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
    jobProgressDetectingEntitiesEntityType :: Text,
    jobProgressDetectingEntitiesAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobProgressDetectingEntities where parseJSON = checked "JobProgressDetectingEntities" $ withObject "JobProgressDetectingEntities" (\fields -> JobProgressDetectingEntities <$> (fields .: "code") <*> (fields .: "entityType") <*> traverse parseJSON (withoutFields ["code", "entityType"] fields))

instance ToJSON JobProgressDetectingEntities where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressDetectingEntitiesCode value))], [("entityType", toJSON (jobProgressDetectingEntitiesEntityType value))]]) <> fmap toJSON (withoutFields ["code", "entityType"] (jobProgressDetectingEntitiesAdditionalProperties value)))

data JobProgressDetectingEntitiesCode = JobProgressDetectingEntitiesCodeDetectingU2d_entities deriving (Eq, Show)

instance FromJSON JobProgressDetectingEntitiesCode where parseJSON = checked "JobProgressDetectingEntitiesCode" $ \value -> if value == String "detecting-entities" then pure JobProgressDetectingEntitiesCodeDetectingU2d_entities else fail "unknown enumeration member"

instance ToJSON JobProgressDetectingEntitiesCode where toJSON JobProgressDetectingEntitiesCodeDetectingU2d_entities = String "detecting-entities"

jobProgressDetectingEntitiesCodeText :: JobProgressDetectingEntitiesCode -> Text
jobProgressDetectingEntitiesCodeText JobProgressDetectingEntitiesCodeDetectingU2d_entities = "detecting-entities"
