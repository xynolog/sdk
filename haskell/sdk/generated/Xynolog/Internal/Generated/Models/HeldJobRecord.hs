-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.HeldJobRecord (HeldJobRecord (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobParams
import Xynolog.Internal.Generated.Models.JobType
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UnitCursor

data HeldJobRecord = HeldJobRecord
  { heldJobRecordJobId :: JobId,
    heldJobRecordJobType :: JobType,
    heldJobRecordResourceId :: ResourceId,
    heldJobRecordParams :: JobParams,
    heldJobRecordCompletedUnits :: [Text],
    heldJobRecordUnitCursors :: KM.KeyMap UnitCursor,
    heldJobRecordRetryCount :: Integer,
    heldJobRecordMaxRetries :: Integer
  }
  deriving (Eq, Show)

instance FromJSON HeldJobRecord where parseJSON = checked "HeldJobRecord" $ withObject "HeldJobRecord" (\fields -> HeldJobRecord <$> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "resourceId") <*> (fields .: "params") <*> (fields .: "completedUnits") <*> (fields .: "unitCursors") <*> (fields .: "retryCount") <*> (fields .: "maxRetries"))

instance ToJSON HeldJobRecord where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (heldJobRecordJobId value))], [("jobType", toJSON (heldJobRecordJobType value))], [("resourceId", toJSON (heldJobRecordResourceId value))], [("params", toJSON (heldJobRecordParams value))], [("completedUnits", toJSON (heldJobRecordCompletedUnits value))], [("unitCursors", toJSON (heldJobRecordUnitCursors value))], [("retryCount", toJSON (heldJobRecordRetryCount value))], [("maxRetries", toJSON (heldJobRecordMaxRetries value))]]))
