-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DispatcherHealth (DispatcherHealth (..), DispatcherHealthQueue (..), dispatcherHealthQueueText, DispatcherHealthStatus (..), dispatcherHealthStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data DispatcherHealth = DispatcherHealth
  { dispatcherHealthQueue :: DispatcherHealthQueue,
    dispatcherHealthStatus :: DispatcherHealthStatus
  }
  deriving (Eq, Show)

instance FromJSON DispatcherHealth where parseJSON = checked "DispatcherHealth" $ withObject "DispatcherHealth" (\fields -> DispatcherHealth <$> (fields .: "queue") <*> (fields .: "status"))

instance ToJSON DispatcherHealth where toJSON value = Object (KM.fromList (concat [[("queue", toJSON (dispatcherHealthQueue value))], [("status", toJSON (dispatcherHealthStatus value))]]))

data DispatcherHealthQueue = DispatcherHealthQueueJetstream deriving (Eq, Show)

instance FromJSON DispatcherHealthQueue where parseJSON = checked "DispatcherHealthQueue" $ \value -> if value == String "jetstream" then pure DispatcherHealthQueueJetstream else fail "unknown enumeration member"

instance ToJSON DispatcherHealthQueue where toJSON DispatcherHealthQueueJetstream = String "jetstream"

dispatcherHealthQueueText :: DispatcherHealthQueue -> Text
dispatcherHealthQueueText DispatcherHealthQueueJetstream = "jetstream"

data DispatcherHealthStatus = DispatcherHealthStatusOk deriving (Eq, Show)

instance FromJSON DispatcherHealthStatus where parseJSON = checked "DispatcherHealthStatus" $ \value -> if value == String "ok" then pure DispatcherHealthStatusOk else fail "unknown enumeration member"

instance ToJSON DispatcherHealthStatus where toJSON DispatcherHealthStatusOk = String "ok"

dispatcherHealthStatusText :: DispatcherHealthStatus -> Text
dispatcherHealthStatusText DispatcherHealthStatusOk = "ok"
