-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DispatcherConfig (DispatcherConfig (..), DispatcherConfigQueue (..), DispatcherConfigTiming (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbIdentity
import Xynolog.Internal.Generated.Models.LogFormat
import Xynolog.Internal.Generated.Models.LogLevel
import Xynolog.Internal.Generated.Models.ServiceIdentity

data DispatcherConfig = DispatcherConfig
  { dispatcherConfigKb :: KbIdentity,
    dispatcherConfigGatewayUrl :: Text,
    dispatcherConfigIdentity :: ServiceIdentity,
    dispatcherConfigQueue :: DispatcherConfigQueue,
    dispatcherConfigPort :: Integer,
    dispatcherConfigTiming :: DispatcherConfigTiming,
    dispatcherConfigLogLevel :: LogLevel,
    dispatcherConfigLogFormat :: LogFormat
  }
  deriving (Eq, Show)

instance FromJSON DispatcherConfig where parseJSON = checked "DispatcherConfig" $ withObject "DispatcherConfig" (\fields -> DispatcherConfig <$> (fields .: "kb") <*> (fields .: "gatewayUrl") <*> (fields .: "identity") <*> (fields .: "queue") <*> (fields .: "port") <*> (fields .: "timing") <*> (fields .: "logLevel") <*> (fields .: "logFormat"))

instance ToJSON DispatcherConfig where toJSON value = Object (KM.fromList (concat [[("kb", toJSON (dispatcherConfigKb value))], [("gatewayUrl", toJSON (dispatcherConfigGatewayUrl value))], [("identity", toJSON (dispatcherConfigIdentity value))], [("queue", toJSON (dispatcherConfigQueue value))], [("port", toJSON (dispatcherConfigPort value))], [("timing", toJSON (dispatcherConfigTiming value))], [("logLevel", toJSON (dispatcherConfigLogLevel value))], [("logFormat", toJSON (dispatcherConfigLogFormat value))]]))

data DispatcherConfigQueue = DispatcherConfigQueue
  { dispatcherConfigQueueServers :: Text,
    dispatcherConfigQueueUserEnv :: Maybe Text,
    dispatcherConfigQueuePasswordEnv :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON DispatcherConfigQueue where parseJSON = checked "DispatcherConfigQueue" $ withObject "DispatcherConfigQueue" (\fields -> DispatcherConfigQueue <$> (fields .: "servers") <*> optional fields "userEnv" <*> optional fields "passwordEnv")

instance ToJSON DispatcherConfigQueue where toJSON value = Object (KM.fromList (concat [[("servers", toJSON (dispatcherConfigQueueServers value))], optionalPair "userEnv" (dispatcherConfigQueueUserEnv value), optionalPair "passwordEnv" (dispatcherConfigQueuePasswordEnv value)]))

data DispatcherConfigTiming = DispatcherConfigTiming
  { dispatcherConfigTimingTickMs :: Integer,
    dispatcherConfigTimingStaleRunningMs :: Integer,
    dispatcherConfigTimingAckWaitMs :: Integer,
    dispatcherConfigTimingRetentionMs :: Integer,
    dispatcherConfigTimingRetentionSweepMs :: Integer,
    dispatcherConfigTimingProgressWriteIntervalMs :: Integer,
    dispatcherConfigTimingBootDeadlineMs :: Integer
  }
  deriving (Eq, Show)

instance FromJSON DispatcherConfigTiming where parseJSON = checked "DispatcherConfigTiming" $ withObject "DispatcherConfigTiming" (\fields -> DispatcherConfigTiming <$> (fields .: "tickMs") <*> (fields .: "staleRunningMs") <*> (fields .: "ackWaitMs") <*> (fields .: "retentionMs") <*> (fields .: "retentionSweepMs") <*> (fields .: "progressWriteIntervalMs") <*> (fields .: "bootDeadlineMs"))

instance ToJSON DispatcherConfigTiming where toJSON value = Object (KM.fromList (concat [[("tickMs", toJSON (dispatcherConfigTimingTickMs value))], [("staleRunningMs", toJSON (dispatcherConfigTimingStaleRunningMs value))], [("ackWaitMs", toJSON (dispatcherConfigTimingAckWaitMs value))], [("retentionMs", toJSON (dispatcherConfigTimingRetentionMs value))], [("retentionSweepMs", toJSON (dispatcherConfigTimingRetentionSweepMs value))], [("progressWriteIntervalMs", toJSON (dispatcherConfigTimingProgressWriteIntervalMs value))], [("bootDeadlineMs", toJSON (dispatcherConfigTimingBootDeadlineMs value))]]))
