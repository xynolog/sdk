-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SmelterHealth (SmelterHealth (..), SmelterHealthIndex (..), SmelterHealthIndexStamp (..), SmelterHealthIndexStampEmbedding (..), SmelterHealthReconcile (..), SmelterHealthReconcilePhase (..), SmelterHealthStatus (..), SmelterHealthStream (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FollowerFollowing
import Xynolog.Internal.Generated.Models.KbDid
import Xynolog.Internal.Generated.Models.SmelterChunking
import Xynolog.Internal.Generated.Models.SmelterReconcileSummary

data SmelterHealth = SmelterHealth
  { smelterHealthEventsProcessed :: Integer,
    smelterHealthFollowing :: FollowerFollowing,
    smelterHealthIndex :: SmelterHealthIndex,
    smelterHealthKb :: KbDid,
    smelterHealthReconcile :: SmelterHealthReconcile,
    smelterHealthStatus :: SmelterHealthStatus,
    smelterHealthStream :: SmelterHealthStream
  }
  deriving (Eq, Show)

instance FromJSON SmelterHealth where parseJSON = checked "SmelterHealth" $ withObject "SmelterHealth" (\fields -> SmelterHealth <$> (fields .: "eventsProcessed") <*> (fields .: "following") <*> (fields .: "index") <*> (fields .: "kb") <*> (fields .: "reconcile") <*> (fields .: "status") <*> (fields .: "stream"))

instance ToJSON SmelterHealth where toJSON value = Object (KM.fromList (concat [[("eventsProcessed", toJSON (smelterHealthEventsProcessed value))], [("following", toJSON (smelterHealthFollowing value))], [("index", toJSON (smelterHealthIndex value))], [("kb", toJSON (smelterHealthKb value))], [("reconcile", toJSON (smelterHealthReconcile value))], [("status", toJSON (smelterHealthStatus value))], [("stream", toJSON (smelterHealthStream value))]]))

data SmelterHealthIndex = SmelterHealthIndex
  { smelterHealthIndexMadeAnew :: Bool,
    smelterHealthIndexStamp :: SmelterHealthIndexStamp
  }
  deriving (Eq, Show)

instance FromJSON SmelterHealthIndex where parseJSON = checked "SmelterHealthIndex" $ withObject "SmelterHealthIndex" (\fields -> SmelterHealthIndex <$> (fields .: "madeAnew") <*> (fields .: "stamp"))

instance ToJSON SmelterHealthIndex where toJSON value = Object (KM.fromList (concat [[("madeAnew", toJSON (smelterHealthIndexMadeAnew value))], [("stamp", toJSON (smelterHealthIndexStamp value))]]))

data SmelterHealthIndexStamp = SmelterHealthIndexStamp
  { smelterHealthIndexStampChunking :: SmelterChunking,
    smelterHealthIndexStampEmbedding :: SmelterHealthIndexStampEmbedding
  }
  deriving (Eq, Show)

instance FromJSON SmelterHealthIndexStamp where parseJSON = checked "SmelterHealthIndexStamp" $ withObject "SmelterHealthIndexStamp" (\fields -> SmelterHealthIndexStamp <$> (fields .: "chunking") <*> (fields .: "embedding"))

instance ToJSON SmelterHealthIndexStamp where toJSON value = Object (KM.fromList (concat [[("chunking", toJSON (smelterHealthIndexStampChunking value))], [("embedding", toJSON (smelterHealthIndexStampEmbedding value))]]))

data SmelterHealthIndexStampEmbedding = SmelterHealthIndexStampEmbedding
  { smelterHealthIndexStampEmbeddingModel :: Text,
    smelterHealthIndexStampEmbeddingType :: Text
  }
  deriving (Eq, Show)

instance FromJSON SmelterHealthIndexStampEmbedding where parseJSON = checked "SmelterHealthIndexStampEmbedding" $ withObject "SmelterHealthIndexStampEmbedding" (\fields -> SmelterHealthIndexStampEmbedding <$> (fields .: "model") <*> (fields .: "type"))

instance ToJSON SmelterHealthIndexStampEmbedding where toJSON value = Object (KM.fromList (concat [[("model", toJSON (smelterHealthIndexStampEmbeddingModel value))], [("type", toJSON (smelterHealthIndexStampEmbeddingType value))]]))

data SmelterHealthReconcile = SmelterHealthReconcile
  { smelterHealthReconcileError :: Maybe Text,
    smelterHealthReconcilePhase :: SmelterHealthReconcilePhase,
    smelterHealthReconcileSummary :: Maybe SmelterReconcileSummary
  }
  deriving (Eq, Show)

instance FromJSON SmelterHealthReconcile where parseJSON = checked "SmelterHealthReconcile" $ withObject "SmelterHealthReconcile" (\fields -> SmelterHealthReconcile <$> optional fields "error" <*> (fields .: "phase") <*> optional fields "summary")

instance ToJSON SmelterHealthReconcile where toJSON value = Object (KM.fromList (concat [optionalPair "error" (smelterHealthReconcileError value), [("phase", toJSON (smelterHealthReconcilePhase value))], optionalPair "summary" (smelterHealthReconcileSummary value)]))

data SmelterHealthReconcilePhase = SmelterHealthReconcilePhasePending | SmelterHealthReconcilePhaseRunning | SmelterHealthReconcilePhaseDone | SmelterHealthReconcilePhaseFailed deriving (Eq, Show)

instance FromJSON SmelterHealthReconcilePhase where parseJSON = checked "SmelterHealthReconcilePhase" $ \value -> if value == String "pending" then pure SmelterHealthReconcilePhasePending else if value == String "running" then pure SmelterHealthReconcilePhaseRunning else if value == String "done" then pure SmelterHealthReconcilePhaseDone else if value == String "failed" then pure SmelterHealthReconcilePhaseFailed else fail "unknown enumeration member"

instance ToJSON SmelterHealthReconcilePhase where
  toJSON SmelterHealthReconcilePhasePending = String "pending"
  toJSON SmelterHealthReconcilePhaseRunning = String "running"
  toJSON SmelterHealthReconcilePhaseDone = String "done"
  toJSON SmelterHealthReconcilePhaseFailed = String "failed"

data SmelterHealthStatus = SmelterHealthStatusOk deriving (Eq, Show)

instance FromJSON SmelterHealthStatus where parseJSON = checked "SmelterHealthStatus" $ \value -> if value == String "ok" then pure SmelterHealthStatusOk else fail "unknown enumeration member"

instance ToJSON SmelterHealthStatus where toJSON SmelterHealthStatusOk = String "ok"

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
