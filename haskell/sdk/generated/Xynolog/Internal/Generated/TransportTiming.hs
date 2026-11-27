-- Generated from protocol/specs/src/client/timing.json; do not edit.
-- Regenerate: make generate (codegen/lib/timing/haskell.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.TransportTiming (TransportTiming (..), protocolTransportTiming) where

import Control.Monad (unless)
import Data.Aeson (FromJSON (..), ToJSON (..), object, withObject, (.:), (.=))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Timing qualified as Base
import Xynolog.Types (RetryBudget)

-- | What a caller may set of the timing a transport keeps: each member is the entry of protocol/specs/src/client/timing.json that its name says, and has the table's value unless the caller states another.
data TransportTiming = TransportTiming
  { emitRetry :: RetryBudget,
    httpRequestTimeoutMs :: Integer,
    streamOpenTimeoutMs :: Integer,
    reconnectMs :: Integer,
    lingerMs :: Integer,
    seenEventIdsCount :: Integer,
    lazyRemoveMs :: Integer
  }
  deriving (Eq, Show)

protocolTransportTiming :: TransportTiming
protocolTransportTiming = TransportTiming {emitRetry = Base.emitRetry, httpRequestTimeoutMs = Base.httpRequestTimeoutMs, streamOpenTimeoutMs = Base.streamOpenTimeoutMs, reconnectMs = Base.reconnectMs, lingerMs = Base.lingerMs, seenEventIdsCount = Base.seenEventIdsCount, lazyRemoveMs = Base.lazyRemoveMs}

instance ToJSON TransportTiming where toJSON value = object ["emitRetry" .= emitRetry value, "httpRequestTimeoutMs" .= httpRequestTimeoutMs value, "streamOpenTimeoutMs" .= streamOpenTimeoutMs value, "reconnectMs" .= reconnectMs value, "lingerMs" .= lingerMs value, "seenEventIdsCount" .= seenEventIdsCount value, "lazyRemoveMs" .= lazyRemoveMs value]

instance FromJSON TransportTiming where
  parseJSON = withObject "TransportTiming" $ \fields -> do
    unless (all (`elem` ["emitRetry", "httpRequestTimeoutMs", "streamOpenTimeoutMs", "reconnectMs", "lingerMs", "seenEventIdsCount", "lazyRemoveMs"]) (KM.keys fields)) (fail "Unknown timing member")
    value <- TransportTiming <$> (fields .: "emitRetry") <*> (fields .: "httpRequestTimeoutMs") <*> (fields .: "streamOpenTimeoutMs") <*> (fields .: "reconnectMs") <*> (fields .: "lingerMs") <*> (fields .: "seenEventIdsCount") <*> (fields .: "lazyRemoveMs")
    unless (all (>= 0) [httpRequestTimeoutMs value, streamOpenTimeoutMs value, reconnectMs value, lingerMs value, seenEventIdsCount value, lazyRemoveMs value]) (fail "Negative timing member")
    pure value
