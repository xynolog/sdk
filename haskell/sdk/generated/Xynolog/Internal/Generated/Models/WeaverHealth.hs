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
  { weaverHealthFollowing :: FollowerFollowing,
    weaverHealthKb :: KbDid,
    weaverHealthReconcile :: WeaverHealthReconcile,
    weaverHealthStatus :: WeaverHealthStatus
  }
  deriving (Eq, Show)

instance FromJSON WeaverHealth where parseJSON = checked "WeaverHealth" $ withObject "WeaverHealth" (\fields -> WeaverHealth <$> (fields .: "following") <*> (fields .: "kb") <*> (fields .: "reconcile") <*> (fields .: "status"))

instance ToJSON WeaverHealth where toJSON value = Object (KM.fromList (concat [[("following", toJSON (weaverHealthFollowing value))], [("kb", toJSON (weaverHealthKb value))], [("reconcile", toJSON (weaverHealthReconcile value))], [("status", toJSON (weaverHealthStatus value))]]))

data WeaverHealthReconcile = WeaverHealthReconcile
  { weaverHealthReconcileError :: Maybe Text,
    weaverHealthReconcilePhase :: WeaverHealthReconcilePhase,
    weaverHealthReconcileSummary :: Maybe WeaverHealthReconcileSummary
  }
  deriving (Eq, Show)

instance FromJSON WeaverHealthReconcile where parseJSON = checked "WeaverHealthReconcile" $ withObject "WeaverHealthReconcile" (\fields -> WeaverHealthReconcile <$> optional fields "error" <*> (fields .: "phase") <*> optional fields "summary")

instance ToJSON WeaverHealthReconcile where toJSON value = Object (KM.fromList (concat [optionalPair "error" (weaverHealthReconcileError value), [("phase", toJSON (weaverHealthReconcilePhase value))], optionalPair "summary" (weaverHealthReconcileSummary value)]))

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
  { weaverHealthReconcileSummaryDivergent :: Integer,
    weaverHealthReconcileSummaryHealFailures :: Integer,
    weaverHealthReconcileSummaryHealed :: Integer,
    weaverHealthReconcileSummaryOrphaned :: Integer,
    weaverHealthReconcileSummaryResourcesChecked :: Integer
  }
  deriving (Eq, Show)

instance FromJSON WeaverHealthReconcileSummary where parseJSON = checked "WeaverHealthReconcileSummary" $ withObject "WeaverHealthReconcileSummary" (\fields -> WeaverHealthReconcileSummary <$> (fields .: "divergent") <*> (fields .: "healFailures") <*> (fields .: "healed") <*> (fields .: "orphaned") <*> (fields .: "resourcesChecked"))

instance ToJSON WeaverHealthReconcileSummary where toJSON value = Object (KM.fromList (concat [[("divergent", toJSON (weaverHealthReconcileSummaryDivergent value))], [("healFailures", toJSON (weaverHealthReconcileSummaryHealFailures value))], [("healed", toJSON (weaverHealthReconcileSummaryHealed value))], [("orphaned", toJSON (weaverHealthReconcileSummaryOrphaned value))], [("resourcesChecked", toJSON (weaverHealthReconcileSummaryResourcesChecked value))]]))

data WeaverHealthStatus = WeaverHealthStatusOk deriving (Eq, Show)

instance FromJSON WeaverHealthStatus where parseJSON = checked "WeaverHealthStatus" $ \value -> if value == String "ok" then pure WeaverHealthStatusOk else fail "unknown enumeration member"

instance ToJSON WeaverHealthStatus where toJSON WeaverHealthStatusOk = String "ok"

weaverHealthStatusText :: WeaverHealthStatus -> Text
weaverHealthStatusText WeaverHealthStatusOk = "ok"
