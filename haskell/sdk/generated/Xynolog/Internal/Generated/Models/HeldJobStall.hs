-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.HeldJobStall (HeldJobStall (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType

data HeldJobStall = HeldJobStall
  { heldJobStallJobId :: JobId,
    heldJobStallJobType :: JobType,
    heldJobStallHeldSince :: Text,
    heldJobStallLastActivityAt :: Text,
    heldJobStallSilentForMs :: Integer,
    heldJobStallThresholdMs :: Integer
  }
  deriving (Eq, Show)

instance FromJSON HeldJobStall where parseJSON = checked "HeldJobStall" $ withObject "HeldJobStall" (\fields -> HeldJobStall <$> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "heldSince") <*> (fields .: "lastActivityAt") <*> (fields .: "silentForMs") <*> (fields .: "thresholdMs"))

instance ToJSON HeldJobStall where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (heldJobStallJobId value))], [("jobType", toJSON (heldJobStallJobType value))], [("heldSince", toJSON (heldJobStallHeldSince value))], [("lastActivityAt", toJSON (heldJobStallLastActivityAt value))], [("silentForMs", toJSON (heldJobStallSilentForMs value))], [("thresholdMs", toJSON (heldJobStallThresholdMs value))]]))
