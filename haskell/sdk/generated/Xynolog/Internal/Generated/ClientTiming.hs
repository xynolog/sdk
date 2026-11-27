-- Generated from protocol/specs/src/client/timing.json; do not edit.
-- Regenerate: make generate (codegen/lib/timing/haskell.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.ClientTiming (ClientTiming (..), protocolClientTiming) where

import Control.Monad (unless)
import Data.Aeson (FromJSON (..), ToJSON (..), object, withObject, (.:), (.=))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Timing qualified as Base

-- | What a caller may set of the timing a client keeps: each member is the entry of protocol/specs/src/client/timing.json that its name says, and has the table's value unless the caller states another.
data ClientTiming = ClientTiming
  { busRequestTimeoutMs :: Integer,
    invalidationWindowMs :: Integer,
    jobSilenceMs :: Integer,
    jobStatusPollMs :: Integer
  }
  deriving (Eq, Show)

protocolClientTiming :: ClientTiming
protocolClientTiming = ClientTiming {busRequestTimeoutMs = Base.busRequestTimeoutMs, invalidationWindowMs = Base.invalidationWindowMs, jobSilenceMs = Base.jobSilenceMs, jobStatusPollMs = Base.jobStatusPollMs}

instance ToJSON ClientTiming where toJSON value = object ["busRequestTimeoutMs" .= busRequestTimeoutMs value, "invalidationWindowMs" .= invalidationWindowMs value, "jobSilenceMs" .= jobSilenceMs value, "jobStatusPollMs" .= jobStatusPollMs value]

instance FromJSON ClientTiming where
  parseJSON = withObject "ClientTiming" $ \fields -> do
    unless (all (`elem` ["busRequestTimeoutMs", "invalidationWindowMs", "jobSilenceMs", "jobStatusPollMs"]) (KM.keys fields)) (fail "Unknown timing member")
    value <- ClientTiming <$> (fields .: "busRequestTimeoutMs") <*> (fields .: "invalidationWindowMs") <*> (fields .: "jobSilenceMs") <*> (fields .: "jobStatusPollMs")
    unless (all (>= 0) [busRequestTimeoutMs value, invalidationWindowMs value, jobSilenceMs value, jobStatusPollMs value]) (fail "Negative timing member")
    pure value
