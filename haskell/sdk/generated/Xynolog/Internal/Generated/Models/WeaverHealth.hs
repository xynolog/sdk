-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WeaverHealth (WeaverHealth (..), WeaverHealthReconcile (..), WeaverHealthReconcilePhase (..), weaverHealthReconcilePhaseText, WeaverHealthReconcileSummary (..), WeaverHealthStatus (..), weaverHealthStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FollowerFollowing
import Xynolog.Internal.Generated.Models.KbDid

data WeaverHealth = WeaverHealth
  { weaverHealthStatus :: WeaverHealthStatus,
    weaverHealthKb :: KbDid,
    weaverHealthFollowing :: FollowerFollowing,
    weaverHealthReconcile :: WeaverHealthReconcile
  }
  deriving (Eq, Show)

instance FromJSON WeaverHealth where parseJSON = checked "WeaverHealth" $ withObject "WeaverHealth" (\fields -> WeaverHealth <$> (fields .: "status") <*> (fields .: "kb") <*> (fields .: "following") <*> (fields .: "reconcile"))

instance ToJSON WeaverHealth where toJSON value = Object (KM.fromList (concat [[("status", toJSON (weaverHealthStatus value))], [("kb", toJSON (weaverHealthKb value))], [("following", toJSON (weaverHealthFollowing value))], [("reconcile", toJSON (weaverHealthReconcile value))]]))

data WeaverHealthReconcile = WeaverHealthReconcile
  { weaverHealthReconcilePhase :: WeaverHealthReconcilePhase,
    weaverHealthReconcileSummary :: Maybe WeaverHealthReconcileSummary,
    weaverHealthReconcileError :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON WeaverHealthReconcile where parseJSON = checked "WeaverHealthReconcile" $ withObject "WeaverHealthReconcile" (\fields -> WeaverHealthReconcile <$> (fields .: "phase") <*> optional fields "summary" <*> optional fields "error")

instance ToJSON WeaverHealthReconcile where toJSON value = Object (KM.fromList (concat [[("phase", toJSON (weaverHealthReconcilePhase value))], optionalPair "summary" (weaverHealthReconcileSummary value), optionalPair "error" (weaverHealthReconcileError value)]))

data WeaverHealthReconcilePhase = WeaverHealthReconcilePhasePending | WeaverHealthReconcilePhaseRunning | WeaverHealthReconcilePhaseDone | WeaverHealthReconcilePhaseFailed deriving (Eq, Show)

instance FromJSON WeaverHealthReconcilePhase where parseJSON = checked "WeaverHealthReconcilePhase" $ \value -> if value == String "pending" then pure WeaverHealthReconcilePhasePending else if value == String "running" then pure WeaverHealthReconcilePhaseRunning else if value == String "done" then pure WeaverHealthReconcilePhaseDone else if value == String "failed" then pure WeaverHealthReconcilePhaseFailed else fail "unknown enumeration member"

instance ToJSON WeaverHealthReconcilePhase where
  toJSON WeaverHealthReconcilePhasePending = String "pending"
  toJSON WeaverHealthReconcilePhaseRunning = String "running"
  toJSON WeaverHealthReconcilePhaseDone = String "done"
  toJSON WeaverHealthReconcilePhaseFailed = String "failed"

weaverHealthReconcilePhaseText :: WeaverHealthReconcilePhase -> Text
weaverHealthReconcilePhaseText WeaverHealthReconcilePhasePending = "pending"
weaverHealthReconcilePhaseText WeaverHealthReconcilePhaseRunning = "running"
weaverHealthReconcilePhaseText WeaverHealthReconcilePhaseDone = "done"
weaverHealthReconcilePhaseText WeaverHealthReconcilePhaseFailed = "failed"

data WeaverHealthReconcileSummary = WeaverHealthReconcileSummary
  { weaverHealthReconcileSummaryResourcesChecked :: Integer,
    weaverHealthReconcileSummaryDivergent :: Integer,
    weaverHealthReconcileSummaryHealed :: Integer,
    weaverHealthReconcileSummaryHealFailures :: Integer,
    weaverHealthReconcileSummaryOrphaned :: Integer
  }
  deriving (Eq, Show)

instance FromJSON WeaverHealthReconcileSummary where parseJSON = checked "WeaverHealthReconcileSummary" $ withObject "WeaverHealthReconcileSummary" (\fields -> WeaverHealthReconcileSummary <$> (fields .: "resourcesChecked") <*> (fields .: "divergent") <*> (fields .: "healed") <*> (fields .: "healFailures") <*> (fields .: "orphaned"))

instance ToJSON WeaverHealthReconcileSummary where toJSON value = Object (KM.fromList (concat [[("resourcesChecked", toJSON (weaverHealthReconcileSummaryResourcesChecked value))], [("divergent", toJSON (weaverHealthReconcileSummaryDivergent value))], [("healed", toJSON (weaverHealthReconcileSummaryHealed value))], [("healFailures", toJSON (weaverHealthReconcileSummaryHealFailures value))], [("orphaned", toJSON (weaverHealthReconcileSummaryOrphaned value))]]))

data WeaverHealthStatus = WeaverHealthStatusOk deriving (Eq, Show)

instance FromJSON WeaverHealthStatus where parseJSON = checked "WeaverHealthStatus" $ \value -> if value == String "ok" then pure WeaverHealthStatusOk else fail "unknown enumeration member"

instance ToJSON WeaverHealthStatus where toJSON WeaverHealthStatusOk = String "ok"

weaverHealthStatusText :: WeaverHealthStatus -> Text
weaverHealthStatusText WeaverHealthStatusOk = "ok"
