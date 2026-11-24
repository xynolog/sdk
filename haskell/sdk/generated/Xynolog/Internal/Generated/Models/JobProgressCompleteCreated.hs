-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressCompleteCreated (JobProgressCompleteCreated (..), JobProgressCompleteCreatedCode (..), jobProgressCompleteCreatedCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Motivation

data JobProgressCompleteCreated = JobProgressCompleteCreated
  { jobProgressCompleteCreatedCode :: JobProgressCompleteCreatedCode,
    jobProgressCompleteCreatedCount :: Integer,
    jobProgressCompleteCreatedMotivation :: Motivation,
    jobProgressCompleteCreatedAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCompleteCreated where parseJSON = checked "JobProgressCompleteCreated" $ withObject "JobProgressCompleteCreated" (\fields -> JobProgressCompleteCreated <$> (fields .: "code") <*> (fields .: "count") <*> (fields .: "motivation") <*> traverse parseJSON (withoutFields ["code", "count", "motivation"] fields))

instance ToJSON JobProgressCompleteCreated where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressCompleteCreatedCode value))], [("count", toJSON (jobProgressCompleteCreatedCount value))], [("motivation", toJSON (jobProgressCompleteCreatedMotivation value))]]) <> fmap toJSON (withoutFields ["code", "count", "motivation"] (jobProgressCompleteCreatedAdditionalProperties value)))

data JobProgressCompleteCreatedCode = JobProgressCompleteCreatedCodeCompleteU2d_created deriving (Eq, Show)

instance FromJSON JobProgressCompleteCreatedCode where parseJSON = checked "JobProgressCompleteCreatedCode" $ \value -> if value == String "complete-created" then pure JobProgressCompleteCreatedCodeCompleteU2d_created else fail "unknown enumeration member"

instance ToJSON JobProgressCompleteCreatedCode where toJSON JobProgressCompleteCreatedCodeCompleteU2d_created = String "complete-created"

jobProgressCompleteCreatedCodeText :: JobProgressCompleteCreatedCode -> Text
jobProgressCompleteCreatedCodeText JobProgressCompleteCreatedCodeCompleteU2d_created = "complete-created"
