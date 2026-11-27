-- Generated from protocol/specs/src/client/timing.json; do not edit.
-- Regenerate: make generate (codegen/lib/timing/haskell.ml)
module Xynolog.Internal.Generated.TimingSettings (Settings (..), settingsOf) where

import Xynolog.Internal.Generated.ClientTiming qualified as Client
import Xynolog.Internal.Generated.TransportTiming qualified as Transport
import Xynolog.Timing qualified as Base
import Xynolog.Types (RetryBudget)

data Settings = Settings
  { busRequestTimeoutMs :: Integer,
    emitTimeoutMs :: Integer,
    emitRetry :: RetryBudget,
    httpRequestTimeoutMs :: Integer,
    requestRetryPauseMs :: Integer,
    streamOpenTimeoutMs :: Integer,
    reconnectMs :: Integer,
    maxReconnectMs :: Integer,
    degradedThresholdMs :: Integer,
    lingerMs :: Integer,
    seenEventIdsCount :: Integer,
    reconnectDebounceMs :: Integer,
    lazyRemoveMs :: Integer,
    refreshRetry :: RetryBudget,
    refreshBeforeExpMs :: Integer,
    minRefreshDelayMs :: Integer,
    devicePollMs :: Integer,
    deviceSlowDownMs :: Integer,
    devicePollFloorMs :: Integer,
    invalidationWindowMs :: Integer,
    saveDebounceMs :: Integer,
    maxStoredBytesCount :: Integer,
    errorsKeptForFirstReaderCount :: Integer,
    jobSilenceMs :: Integer,
    jobStatusPollMs :: Integer,
    jobPollMs :: Integer,
    jobPollTimeoutMs :: Integer,
    generationStallFloorMs :: Integer,
    generationStallPerTokenMs :: Integer,
    generationStallAssumedTokensCount :: Integer,
    delegateSilenceMs :: Integer,
    jobClaimTimeoutMs :: Integer,
    heldJobStallMs :: Integer,
    heldJobStallCheckMs :: Integer,
    markCommitTimeoutMs :: Integer,
    generatedTextAsksCount :: Integer,
    anchoredTextReaskMs :: Integer,
    hoverDelayMs :: Integer,
    searchDebounceMs :: Integer,
    discoveryIntervalMs :: Integer,
    checksAtOnceCount :: Integer
  }
  deriving (Eq, Show)

-- | A caller's records, over the table's values of every other.
settingsOf :: Client.ClientTiming -> Transport.TransportTiming -> Settings
settingsOf client transport = Settings {busRequestTimeoutMs = Client.busRequestTimeoutMs client, emitTimeoutMs = Base.emitTimeoutMs, emitRetry = Transport.emitRetry transport, httpRequestTimeoutMs = Transport.httpRequestTimeoutMs transport, requestRetryPauseMs = Base.requestRetryPauseMs, streamOpenTimeoutMs = Transport.streamOpenTimeoutMs transport, reconnectMs = Transport.reconnectMs transport, maxReconnectMs = Base.maxReconnectMs, degradedThresholdMs = Base.degradedThresholdMs, lingerMs = Transport.lingerMs transport, seenEventIdsCount = Transport.seenEventIdsCount transport, reconnectDebounceMs = Base.reconnectDebounceMs, lazyRemoveMs = Transport.lazyRemoveMs transport, refreshRetry = Base.refreshRetry, refreshBeforeExpMs = Base.refreshBeforeExpMs, minRefreshDelayMs = Base.minRefreshDelayMs, devicePollMs = Base.devicePollMs, deviceSlowDownMs = Base.deviceSlowDownMs, devicePollFloorMs = Base.devicePollFloorMs, invalidationWindowMs = Client.invalidationWindowMs client, saveDebounceMs = Base.saveDebounceMs, maxStoredBytesCount = Base.maxStoredBytesCount, errorsKeptForFirstReaderCount = Base.errorsKeptForFirstReaderCount, jobSilenceMs = Client.jobSilenceMs client, jobStatusPollMs = Client.jobStatusPollMs client, jobPollMs = Base.jobPollMs, jobPollTimeoutMs = Base.jobPollTimeoutMs, generationStallFloorMs = Base.generationStallFloorMs, generationStallPerTokenMs = Base.generationStallPerTokenMs, generationStallAssumedTokensCount = Base.generationStallAssumedTokensCount, delegateSilenceMs = Base.delegateSilenceMs, jobClaimTimeoutMs = Base.jobClaimTimeoutMs, heldJobStallMs = Base.heldJobStallMs, heldJobStallCheckMs = Base.heldJobStallCheckMs, markCommitTimeoutMs = Base.markCommitTimeoutMs, generatedTextAsksCount = Base.generatedTextAsksCount, anchoredTextReaskMs = Base.anchoredTextReaskMs, hoverDelayMs = Base.hoverDelayMs, searchDebounceMs = Base.searchDebounceMs, discoveryIntervalMs = Base.discoveryIntervalMs, checksAtOnceCount = Base.checksAtOnceCount}
