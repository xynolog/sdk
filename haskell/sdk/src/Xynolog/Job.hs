{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Job (JobNamespace, newJob, queued, progress, complete, fail, status, pollUntilComplete, cancel, claim) where

import Control.Exception (throwIO)
import Control.Monad (when)
import Data.Maybe (fromMaybe)
import Streaming (Of, Stream)
import Xynolog.Bus qualified as Bus
import Xynolog.Channels hiding (JobComplete)
import Xynolog.Channels qualified as Channel
import Xynolog.ErrorCodes (BusRequestCode (BusRequestTimeout))
import Xynolog.Errors (BusRequestError (..))
import Xynolog.EventBus (EventBus)
import Xynolog.Internal.Local qualified as Local
import Xynolog.Timing qualified as Timing
import Xynolog.Timing.Settings qualified as Settings
import Xynolog.Transport qualified as Transport
import Xynolog.Types
import Xynolog.Worker qualified as Worker
import Prelude hiding (fail)

data JobNamespace = JobNamespace Bus.Bus EventBus Transport.Transport Bus.BusOptions Settings.ClientTiming

newJob :: Bus.Bus -> EventBus -> Transport.Transport -> Bus.BusOptions -> Settings.ClientTiming -> JobNamespace
newJob = JobNamespace

queued :: JobNamespace -> (Stream (Of (Bus.Heard JobQueuedEvent)) IO () -> IO result) -> IO result
queued (JobNamespace _ bus _ _ _) = Local.events bus JobQueued NoScope

progress :: JobNamespace -> (Stream (Of (Bus.Heard JobReportProgressCommand)) IO () -> IO result) -> IO result
progress (JobNamespace _ bus _ _ _) = Local.events bus JobReportProgress NoScope

complete :: JobNamespace -> (Stream (Of (Bus.Heard JobCompleteCommand)) IO () -> IO result) -> IO result
complete (JobNamespace _ bus _ _ _) = Local.events bus Channel.JobComplete NoScope

fail :: JobNamespace -> (Stream (Of (Bus.Heard JobFailCommand)) IO () -> IO result) -> IO result
fail (JobNamespace _ bus _ _ _) = Local.events bus JobFail NoScope

status :: JobNamespace -> JobId -> IO JobStatusResponse
status namespace@(JobNamespace _ _ _ _ timing) identity = statusWithin namespace identity (Settings.busRequestTimeoutMs timing)

statusWithin :: JobNamespace -> JobId -> Integer -> IO JobStatusResponse
statusWithin (JobNamespace wire _ _ _ _) identity timeoutMs =
  jobStatusResultResponse
    <$> Bus.request wire JobStatusRequestedOperation (JobStatusRequest identity) timeoutMs

-- | Asks at once, then every interval, and fails as timed out at the limit
-- from its first ask: an ask then in flight, or a wait, ends there. Each
-- status it is told is given to the callback.
pollUntilComplete :: JobNamespace -> JobId -> JobPollOptions -> (JobStatusResponse -> IO ()) -> IO JobStatusResponse
pollUntilComplete namespace@(JobNamespace _ _ _ clock timing) identity options onStatus = do
  let interval = fromMaybe Timing.jobPollMs (jobPollOptionsEveryMs options)
      limit = fromMaybe Timing.jobPollTimeoutMs (jobPollOptionsWithinMs options)
  when (interval < 0 || limit < 0) (ioError (userError "negative job polling interval or timeout"))
  began <- Bus.requestNow clock
  let deadline = began + limit * 1000000
      loop = do
        now <- Bus.requestNow clock
        when (now >= deadline) (throwIO (BusRequestError BusRequestTimeout "job polling deadline expired" Nothing))
        value <- statusWithin namespace identity (min (Settings.busRequestTimeoutMs timing) ((deadline - now + 999999) `div` 1000000))
        onStatus value
        if terminal (jobStatusResponseStatus value)
          then pure value
          else do
            asked <- Bus.requestNow clock
            Bus.requestWaitUntil clock (min deadline (asked + interval * 1000000))
            loop
  loop
  where
    terminal JobStatusResponseStatusPending = False
    terminal JobStatusResponseStatusRunning = False
    terminal JobStatusResponseStatusComplete = True
    terminal JobStatusResponseStatusFailed = True
    terminal JobStatusResponseStatusCancelled = True

cancel :: JobNamespace -> JobId -> IO Bool
cancel (JobNamespace wire _ _ _ timing) identity =
  jobCancelResultCancelled . jobCancelResultBusEnvelopeResponse
    <$> Bus.request wire JobCancelRequestedOperation (JobCancelRequest identity) (Settings.busRequestTimeoutMs timing)

claim :: JobNamespace -> ClaimOptions -> IO Worker.Claims
claim (JobNamespace _ _ carrier clock _) = Worker.newClaims carrier clock
