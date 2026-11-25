-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobDeclined (JobDeclined (..), JobDeclinedDeclined (..), JobDeclinedReason (..), jobDeclinedReasonText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobDeclined = JobDeclined
  { jobDeclinedDeclined :: JobDeclinedDeclined,
    jobDeclinedReason :: JobDeclinedReason
  }
  deriving (Eq, Show)

instance FromJSON JobDeclined where parseJSON = checked "JobDeclined" $ withObject "JobDeclined" (\fields -> JobDeclined <$> (fields .: "declined") <*> (fields .: "reason"))

instance ToJSON JobDeclined where toJSON value = Object (KM.fromList (concat [[("declined", toJSON (jobDeclinedDeclined value))], [("reason", toJSON (jobDeclinedReason value))]]))

data JobDeclinedDeclined = JobDeclinedDeclinedTrue deriving (Eq, Show)

instance FromJSON JobDeclinedDeclined where parseJSON = checked "JobDeclinedDeclined" $ \value -> if value == Bool True then pure JobDeclinedDeclinedTrue else fail "unknown enumeration member"

instance ToJSON JobDeclinedDeclined where toJSON JobDeclinedDeclinedTrue = Bool True

data JobDeclinedReason = JobDeclinedReasonNoTextLayer | JobDeclinedReasonEncrypted | JobDeclinedReasonCorrupt | JobDeclinedReasonTooLarge | JobDeclinedReasonEmpty deriving (Eq, Show)

instance FromJSON JobDeclinedReason where parseJSON = checked "JobDeclinedReason" $ \value -> if value == String "no-text-layer" then pure JobDeclinedReasonNoTextLayer else if value == String "encrypted" then pure JobDeclinedReasonEncrypted else if value == String "corrupt" then pure JobDeclinedReasonCorrupt else if value == String "too-large" then pure JobDeclinedReasonTooLarge else if value == String "empty" then pure JobDeclinedReasonEmpty else fail "unknown enumeration member"

instance ToJSON JobDeclinedReason where
  toJSON JobDeclinedReasonNoTextLayer = String "no-text-layer"
  toJSON JobDeclinedReasonEncrypted = String "encrypted"
  toJSON JobDeclinedReasonCorrupt = String "corrupt"
  toJSON JobDeclinedReasonTooLarge = String "too-large"
  toJSON JobDeclinedReasonEmpty = String "empty"

jobDeclinedReasonText :: JobDeclinedReason -> Text
jobDeclinedReasonText JobDeclinedReasonNoTextLayer = "no-text-layer"
jobDeclinedReasonText JobDeclinedReasonEncrypted = "encrypted"
jobDeclinedReasonText JobDeclinedReasonCorrupt = "corrupt"
jobDeclinedReasonText JobDeclinedReasonTooLarge = "too-large"
jobDeclinedReasonText JobDeclinedReasonEmpty = "empty"
