-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SmelterHealth (SmelterHealth (..), SmelterHealthIndex (..), SmelterHealthIndexStamp (..), SmelterHealthIndexStampEmbedding (..), SmelterHealthReconcile (..), SmelterHealthReconcilePhase (..), smelterHealthReconcilePhaseText, SmelterHealthStatus (..), smelterHealthStatusText, SmelterHealthStream (..), smelterHealthStreamText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FollowerFollowing
import Xynolog.Internal.Generated.Models.KbDid
import Xynolog.Internal.Generated.Models.SmelterChunking
import Xynolog.Internal.Generated.Models.SmelterReconcileSummary

data SmelterHealth = SmelterHealth
  { smelterHealthStatus :: SmelterHealthStatus,
    smelterHealthKb :: KbDid,
    smelterHealthStream :: SmelterHealthStream,
    smelterHealthFollowing :: FollowerFollowing,
    smelterHealthEventsProcessed :: Integer,
    smelterHealthReconcile :: SmelterHealthReconcile,
    smelterHealthIndex :: SmelterHealthIndex
  }
  deriving (Eq, Show)

instance FromJSON SmelterHealth where parseJSON = checked "SmelterHealth" $ withObject "SmelterHealth" (\fields -> SmelterHealth <$> (fields .: "status") <*> (fields .: "kb") <*> (fields .: "stream") <*> (fields .: "following") <*> (fields .: "eventsProcessed") <*> (fields .: "reconcile") <*> (fields .: "index"))

instance ToJSON SmelterHealth where toJSON value = Object (KM.fromList (concat [[("status", toJSON (smelterHealthStatus value))], [("kb", toJSON (smelterHealthKb value))], [("stream", toJSON (smelterHealthStream value))], [("following", toJSON (smelterHealthFollowing value))], [("eventsProcessed", toJSON (smelterHealthEventsProcessed value))], [("reconcile", toJSON (smelterHealthReconcile value))], [("index", toJSON (smelterHealthIndex value))]]))

data SmelterHealthIndex = SmelterHealthIndex
  { smelterHealthIndexStamp :: SmelterHealthIndexStamp,
    smelterHealthIndexMadeAnew :: Bool
  }
  deriving (Eq, Show)

instance FromJSON SmelterHealthIndex where parseJSON = checked "SmelterHealthIndex" $ withObject "SmelterHealthIndex" (\fields -> SmelterHealthIndex <$> (fields .: "stamp") <*> (fields .: "madeAnew"))

instance ToJSON SmelterHealthIndex where toJSON value = Object (KM.fromList (concat [[("stamp", toJSON (smelterHealthIndexStamp value))], [("madeAnew", toJSON (smelterHealthIndexMadeAnew value))]]))

data SmelterHealthIndexStamp = SmelterHealthIndexStamp
  { smelterHealthIndexStampEmbedding :: SmelterHealthIndexStampEmbedding,
    smelterHealthIndexStampChunking :: SmelterChunking
  }
  deriving (Eq, Show)

instance FromJSON SmelterHealthIndexStamp where parseJSON = checked "SmelterHealthIndexStamp" $ withObject "SmelterHealthIndexStamp" (\fields -> SmelterHealthIndexStamp <$> (fields .: "embedding") <*> (fields .: "chunking"))

instance ToJSON SmelterHealthIndexStamp where toJSON value = Object (KM.fromList (concat [[("embedding", toJSON (smelterHealthIndexStampEmbedding value))], [("chunking", toJSON (smelterHealthIndexStampChunking value))]]))

data SmelterHealthIndexStampEmbedding = SmelterHealthIndexStampEmbedding
  { smelterHealthIndexStampEmbeddingType :: Text,
    smelterHealthIndexStampEmbeddingModel :: Text
  }
  deriving (Eq, Show)

instance FromJSON SmelterHealthIndexStampEmbedding where parseJSON = checked "SmelterHealthIndexStampEmbedding" $ withObject "SmelterHealthIndexStampEmbedding" (\fields -> SmelterHealthIndexStampEmbedding <$> (fields .: "type") <*> (fields .: "model"))

instance ToJSON SmelterHealthIndexStampEmbedding where toJSON value = Object (KM.fromList (concat [[("type", toJSON (smelterHealthIndexStampEmbeddingType value))], [("model", toJSON (smelterHealthIndexStampEmbeddingModel value))]]))

data SmelterHealthReconcile = SmelterHealthReconcile
  { smelterHealthReconcilePhase :: SmelterHealthReconcilePhase,
    smelterHealthReconcileSummary :: Maybe SmelterReconcileSummary,
    smelterHealthReconcileError :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON SmelterHealthReconcile where parseJSON = checked "SmelterHealthReconcile" $ withObject "SmelterHealthReconcile" (\fields -> SmelterHealthReconcile <$> (fields .: "phase") <*> optional fields "summary" <*> optional fields "error")

instance ToJSON SmelterHealthReconcile where toJSON value = Object (KM.fromList (concat [[("phase", toJSON (smelterHealthReconcilePhase value))], optionalPair "summary" (smelterHealthReconcileSummary value), optionalPair "error" (smelterHealthReconcileError value)]))

data SmelterHealthReconcilePhase = SmelterHealthReconcilePhasePending | SmelterHealthReconcilePhaseRunning | SmelterHealthReconcilePhaseDone | SmelterHealthReconcilePhaseFailed deriving (Eq, Show)

instance FromJSON SmelterHealthReconcilePhase where parseJSON = checked "SmelterHealthReconcilePhase" $ \value -> if value == String "pending" then pure SmelterHealthReconcilePhasePending else if value == String "running" then pure SmelterHealthReconcilePhaseRunning else if value == String "done" then pure SmelterHealthReconcilePhaseDone else if value == String "failed" then pure SmelterHealthReconcilePhaseFailed else fail "unknown enumeration member"

instance ToJSON SmelterHealthReconcilePhase where
  toJSON SmelterHealthReconcilePhasePending = String "pending"
  toJSON SmelterHealthReconcilePhaseRunning = String "running"
  toJSON SmelterHealthReconcilePhaseDone = String "done"
  toJSON SmelterHealthReconcilePhaseFailed = String "failed"

smelterHealthReconcilePhaseText :: SmelterHealthReconcilePhase -> Text
smelterHealthReconcilePhaseText SmelterHealthReconcilePhasePending = "pending"
smelterHealthReconcilePhaseText SmelterHealthReconcilePhaseRunning = "running"
smelterHealthReconcilePhaseText SmelterHealthReconcilePhaseDone = "done"
smelterHealthReconcilePhaseText SmelterHealthReconcilePhaseFailed = "failed"

data SmelterHealthStatus = SmelterHealthStatusOk deriving (Eq, Show)

instance FromJSON SmelterHealthStatus where parseJSON = checked "SmelterHealthStatus" $ \value -> if value == String "ok" then pure SmelterHealthStatusOk else fail "unknown enumeration member"

instance ToJSON SmelterHealthStatus where toJSON SmelterHealthStatusOk = String "ok"

smelterHealthStatusText :: SmelterHealthStatus -> Text
smelterHealthStatusText SmelterHealthStatusOk = "ok"

data SmelterHealthStream = SmelterHealthStreamInitial | SmelterHealthStreamConnecting | SmelterHealthStreamOpen | SmelterHealthStreamReconnecting | SmelterHealthStreamDegraded | SmelterHealthStreamUnauthenticated | SmelterHealthStreamClosed deriving (Eq, Show)

instance FromJSON SmelterHealthStream where parseJSON = checked "SmelterHealthStream" $ \value -> if value == String "initial" then pure SmelterHealthStreamInitial else if value == String "connecting" then pure SmelterHealthStreamConnecting else if value == String "open" then pure SmelterHealthStreamOpen else if value == String "reconnecting" then pure SmelterHealthStreamReconnecting else if value == String "degraded" then pure SmelterHealthStreamDegraded else if value == String "unauthenticated" then pure SmelterHealthStreamUnauthenticated else if value == String "closed" then pure SmelterHealthStreamClosed else fail "unknown enumeration member"

instance ToJSON SmelterHealthStream where
  toJSON SmelterHealthStreamInitial = String "initial"
  toJSON SmelterHealthStreamConnecting = String "connecting"
  toJSON SmelterHealthStreamOpen = String "open"
  toJSON SmelterHealthStreamReconnecting = String "reconnecting"
  toJSON SmelterHealthStreamDegraded = String "degraded"
  toJSON SmelterHealthStreamUnauthenticated = String "unauthenticated"
  toJSON SmelterHealthStreamClosed = String "closed"

smelterHealthStreamText :: SmelterHealthStream -> Text
smelterHealthStreamText SmelterHealthStreamInitial = "initial"
smelterHealthStreamText SmelterHealthStreamConnecting = "connecting"
smelterHealthStreamText SmelterHealthStreamOpen = "open"
smelterHealthStreamText SmelterHealthStreamReconnecting = "reconnecting"
smelterHealthStreamText SmelterHealthStreamDegraded = "degraded"
smelterHealthStreamText SmelterHealthStreamUnauthenticated = "unauthenticated"
smelterHealthStreamText SmelterHealthStreamClosed = "closed"
