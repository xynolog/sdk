-- Generated from protocol/specs/src/client/surface.json and client/types; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
module Xynolog.Internal.Generated.HeldJob (HasHeldJobRecord (..), jobId, jobType, resourceId, params, completedUnits, unitCursors, retryCount, maxRetries) where

import Data.Text (Text)
import Xynolog.Types (HeldJobRecord (..), HeldJobRecordUnitCursors, JobId, JobParams, JobType, ResourceId)

-- | What holds the HeldJobRecord a claim hands it.
class HasHeldJobRecord held where
  heldJobRecord :: held -> HeldJobRecord

jobId :: (HasHeldJobRecord held) => held -> JobId
jobId = heldJobRecordJobId . heldJobRecord

jobType :: (HasHeldJobRecord held) => held -> JobType
jobType = heldJobRecordJobType . heldJobRecord

resourceId :: (HasHeldJobRecord held) => held -> ResourceId
resourceId = heldJobRecordResourceId . heldJobRecord

params :: (HasHeldJobRecord held) => held -> JobParams
params = heldJobRecordParams . heldJobRecord

-- | The units a worker has finished, merged across checkpoints and failures as a set.
completedUnits :: (HasHeldJobRecord held) => held -> [Text]
completedUnits = heldJobRecordCompletedUnits . heldJobRecord

-- | The furthest each unit begun got, keyed by unit, with what it had counted there. A finished unit keeps its cursor: where it ended, and its final counts.
unitCursors :: (HasHeldJobRecord held) => held -> HeldJobRecordUnitCursors
unitCursors = heldJobRecordUnitCursors . heldJobRecord

retryCount :: (HasHeldJobRecord held) => held -> Integer
retryCount = heldJobRecordRetryCount . heldJobRecord

-- | How many transient failures the queue retries: 0 for generation, whose re-run produces different content; 1 for every other type.
maxRetries :: (HasHeldJobRecord held) => held -> Integer
maxRetries = heldJobRecordMaxRetries . heldJobRecord
