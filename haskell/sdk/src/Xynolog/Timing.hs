-- Generated from protocol/specs/src/client/timing.json; do not edit.
-- Regenerate: make generate (codegen/lib/timing/haskell.ml)
module Xynolog.Timing (busRequestTimeoutMs, emitTimeoutMs, emitRetry, httpRequestTimeoutMs, requestRetryPauseMs, streamOpenTimeoutMs, reconnectMs, maxReconnectMs, degradedThresholdMs, lingerMs, seenEventIdsCount, reconnectDebounceMs, lazyRemoveMs, refreshRetry, refreshBeforeExpMs, minRefreshDelayMs, devicePollMs, deviceSlowDownMs, devicePollFloorMs, invalidationWindowMs, saveDebounceMs, maxStoredBytesCount, errorsKeptForFirstReaderCount, jobSilenceMs, jobStatusPollMs, jobPollMs, jobPollTimeoutMs, generationStallFloorMs, generationStallPerTokenMs, generationStallAssumedTokensCount, delegateSilenceMs, jobClaimTimeoutMs, heldJobStallMs, heldJobStallCheckMs, markCommitTimeoutMs, generatedTextAsksCount, anchoredTextReaskMs, hoverDelayMs, searchDebounceMs, discoveryIntervalMs, checksAtOnceCount) where

import Xynolog.Types (RetryBudget (..))

busRequestTimeoutMs :: Integer
busRequestTimeoutMs = 30000

emitTimeoutMs :: Integer
emitTimeoutMs = 30000

emitRetry :: RetryBudget
emitRetry = RetryBudget {retryBudgetAttempts = 4, retryBudgetInitialDelayMs = 1000, retryBudgetMaxDelayMs = 4000}

httpRequestTimeoutMs :: Integer
httpRequestTimeoutMs = 30000

requestRetryPauseMs :: Integer
requestRetryPauseMs = 300

streamOpenTimeoutMs :: Integer
streamOpenTimeoutMs = 30000

reconnectMs :: Integer
reconnectMs = 5000

maxReconnectMs :: Integer
maxReconnectMs = 60000

degradedThresholdMs :: Integer
degradedThresholdMs = 3000

lingerMs :: Integer
lingerMs = 1000

seenEventIdsCount :: Integer
seenEventIdsCount = 512

reconnectDebounceMs :: Integer
reconnectDebounceMs = 100

lazyRemoveMs :: Integer
lazyRemoveMs = 5000

refreshRetry :: RetryBudget
refreshRetry = RetryBudget {retryBudgetAttempts = 4, retryBudgetInitialDelayMs = 500, retryBudgetMaxDelayMs = 4000}

refreshBeforeExpMs :: Integer
refreshBeforeExpMs = 300000

minRefreshDelayMs :: Integer
minRefreshDelayMs = 10000

devicePollMs :: Integer
devicePollMs = 5000

deviceSlowDownMs :: Integer
deviceSlowDownMs = 5000

devicePollFloorMs :: Integer
devicePollFloorMs = 1000

invalidationWindowMs :: Integer
invalidationWindowMs = 1000

saveDebounceMs :: Integer
saveDebounceMs = 50

maxStoredBytesCount :: Integer
maxStoredBytesCount = 2097152

errorsKeptForFirstReaderCount :: Integer
errorsKeptForFirstReaderCount = 100

jobSilenceMs :: Integer
jobSilenceMs = 10000

jobStatusPollMs :: Integer
jobStatusPollMs = 5000

jobPollMs :: Integer
jobPollMs = 1000

jobPollTimeoutMs :: Integer
jobPollTimeoutMs = 60000

generationStallFloorMs :: Integer
generationStallFloorMs = 120000

generationStallPerTokenMs :: Integer
generationStallPerTokenMs = 75

generationStallAssumedTokensCount :: Integer
generationStallAssumedTokensCount = 500

delegateSilenceMs :: Integer
delegateSilenceMs = 180000

jobClaimTimeoutMs :: Integer
jobClaimTimeoutMs = 10000

heldJobStallMs :: Integer
heldJobStallMs = 900000

heldJobStallCheckMs :: Integer
heldJobStallCheckMs = 60000

markCommitTimeoutMs :: Integer
markCommitTimeoutMs = 60000

generatedTextAsksCount :: Integer
generatedTextAsksCount = 8

anchoredTextReaskMs :: Integer
anchoredTextReaskMs = 5000

hoverDelayMs :: Integer
hoverDelayMs = 150

searchDebounceMs :: Integer
searchDebounceMs = 250

discoveryIntervalMs :: Integer
discoveryIntervalMs = 5000

checksAtOnceCount :: Integer
checksAtOnceCount = 4
