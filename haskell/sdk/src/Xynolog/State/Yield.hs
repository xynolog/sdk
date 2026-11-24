{-# LANGUAGE OverloadedStrings #-}

-- | The display of generation: progress and its outcome stay until dismissed.
module Xynolog.State.Yield (YieldStateUnit, newYieldStateUnit, isGenerating, progress, outcome, failure, jobId, generate, dismissProgress, dispose) where

import Control.Concurrent.STM
import Control.Exception (Handler (..), SomeException, catches, finally, toException)
import Control.Monad (unless, void, when)
import Control.Monad.IO.Class (liftIO)
import Data.Scientific (Scientific)
import Data.Text (Text)
import Data.Text qualified as Text
import Streaming.Prelude qualified as Stream
import Xynolog.Client qualified as Client
import Xynolog.Delegation qualified as Delegation
import Xynolog.ErrorCodes qualified as Code
import Xynolog.Errors (BusRequestError, TransportError)
import Xynolog.Internal.StateTasks qualified as Tasks
import Xynolog.Internal.StateValue qualified as State
import Xynolog.Running qualified as Running
import Xynolog.Types
import Xynolog.Yield qualified as Yield

data YieldStateUnit
  = YieldStateUnit
      Tasks.Tasks
      Client.Client
      Text
      (State.StateValue Bool)
      (State.StateValue (Maybe JobProgress))
      (State.StateValue (Maybe YieldJobDone))
      (State.StateValue (Maybe SomeException))
      (State.StateValue (Maybe JobId))

newYieldStateUnit :: Client.Client -> Text -> IO YieldStateUnit
newYieldStateUnit client locale = do
  tasks <- Tasks.newTasks "yield state unit is closed"
  atomically
    ( YieldStateUnit tasks client locale
        <$> State.newStateValue False
        <*> State.newStateValue Nothing
        <*> State.newStateValue Nothing
        <*> State.newStateValue Nothing
        <*> State.newStateValue Nothing
    )

isGenerating :: YieldStateUnit -> State.StateValue Bool
isGenerating (YieldStateUnit _ _ _ value _ _ _ _) = value

progress :: YieldStateUnit -> State.StateValue (Maybe JobProgress)
progress (YieldStateUnit _ _ _ _ value _ _ _) = value

outcome :: YieldStateUnit -> State.StateValue (Maybe YieldJobDone)
outcome (YieldStateUnit _ _ _ _ _ value _ _) = value

failure :: YieldStateUnit -> State.StateValue (Maybe SomeException)
failure (YieldStateUnit _ _ _ _ _ _ value _) = value

jobId :: YieldStateUnit -> State.StateValue (Maybe JobId)
jobId (YieldStateUnit _ _ _ _ _ _ _ value) = value

generate :: YieldStateUnit -> GenerationJobParams -> Maybe Scientific -> IO ()
generate unit@(YieldStateUnit tasks client locale _ _ _ _ _) params deadline = do
  accepted <- atomically $ do
    over <- Tasks.closed tasks
    unless over (clear unit >> State.update (jobId unit) Nothing)
    pure (not over)
  when accepted $ Tasks.submit tasks $ \acceptedJob -> do
    created <- newTVarIO Nothing
    let selected = params {generationJobParamsLanguage = case generationJobParamsLanguage params of Nothing -> Just locale; Just value | Text.null value -> Just locale; other -> other}
        report event = do
          case event of { Delegation.Created _ -> acceptedJob; _ -> pure () }
          atomically $ case event of
            Delegation.Created value -> writeTVar created (Just (jobCreatedResultResponseJobId value)) >> State.update (jobId unit) (Just (jobCreatedResultResponseJobId value))
            Delegation.Progress value -> State.update (progress unit) (Just value) >> State.update (isGenerating unit) True
            Delegation.Complete value -> case yieldJobCompleteCommandResult value of
              Just (YieldJobResultYieldJobDone done) -> State.update (outcome unit) (Just done)
              _ -> pure ()
            Delegation.Failed _ -> pure ()
            Delegation.Refused _ -> pure ()
        work = Yield.delegate (Client.yield client) selected deadline >>= \run -> Running.withReports run (void . Stream.mapM_ (liftIO . report))
        failed problem cancelled = atomically $ do
          State.update (failure unit) (Just problem)
          unless cancelled (State.update (progress unit) Nothing)
    work
      `catches` [ Handler (\problem -> failed (toException problem) (Delegation.jobErrorCode problem == Code.JobCancelled)),
                  Handler (\problem -> failed (toException (problem :: BusRequestError)) False),
                  Handler (\problem -> failed (toException (problem :: TransportError)) False)
                ]
    atomically $ do
      State.update (isGenerating unit) False
      ours <- readTVar created
      current <- State.current (jobId unit)
      when (ours /= Nothing && ours == current) (State.update (jobId unit) Nothing)

clear :: YieldStateUnit -> STM ()
clear unit = State.update (progress unit) Nothing >> State.update (outcome unit) Nothing >> State.update (failure unit) Nothing

dismissProgress :: YieldStateUnit -> STM ()
dismissProgress unit@(YieldStateUnit tasks _ _ _ _ _ _ _) = Tasks.closed tasks >>= \over -> unless over (clear unit)

dispose :: YieldStateUnit -> IO ()
dispose unit@(YieldStateUnit tasks _ _ _ _ _ _ _) =
  Tasks.dispose tasks
    `finally` atomically
      (State.complete (isGenerating unit) >> State.complete (progress unit) >> State.complete (outcome unit) >> State.complete (failure unit) >> State.complete (jobId unit))
