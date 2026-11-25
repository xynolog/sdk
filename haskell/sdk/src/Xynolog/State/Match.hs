{-# LANGUAGE OverloadedStrings #-}

-- | Run correlated matching requests on the client's signal plane.
module Xynolog.State.Match (MatchStateUnit, newMatchStateUnit, dispose) where

import Control.Concurrent.STM (atomically)
import Control.Exception (Handler (..), catches)
import Data.Aeson (Value (..))
import Data.Text (Text)
import Xynolog.Channels
import Xynolog.Client qualified as Client
import Xynolog.Errors (BusRequestError (..), TransportError (..))
import Xynolog.Internal.Local qualified as Local
import Xynolog.Internal.StateTasks qualified as Tasks
import Xynolog.Internal.Transport qualified as Transport
import Xynolog.Match qualified as Match
import Xynolog.Running qualified as Running
import Xynolog.Types hiding (MatchSearchFailed)
import Xynolog.Types qualified as Types

newtype MatchStateUnit = MatchStateUnit Tasks.Tasks

newMatchStateUnit :: Client.Client -> IO MatchStateUnit
newMatchStateUnit client = do
  tasks <- Tasks.newTasks "match state unit is closed"
  Tasks.listen tasks (Client.bus client) [channelName MatchSearchRequested] $ \frame -> do
    let envelope = Transport.wireFrame frame
    case decodePayload MatchSearchRequested (Object (busFramePayloadAdditionalProperties (busFramePayload envelope))) of
      Left _ -> pure ()
      Right input -> Tasks.fork tasks $ do
        let reply :: Text -> IO ()
            reply message =
              atomically
                ( Local.signalWithCorrelation
                    (Client.bus client)
                    MatchSearchFailed
                    (Types.MatchSearchFailed Nothing Nothing message (matchSearchRequestReferenceId input))
                    NoScope
                    (busFrameCorrelationId envelope)
                )
            work = do
              found <-
                Match.search
                  (Client.match client)
                  (matchSearchRequestResourceId input)
                  (matchSearchRequestReferenceId input)
                  (matchSearchRequestContext input)
                  (Just (MatchSearchOptions (matchSearchRequestLimit input) (matchSearchRequestUseSemanticScoring input)))
                  >>= Running.await
              atomically (Local.signalWithCorrelation (Client.bus client) MatchSearchResults found NoScope (busFrameCorrelationId envelope))
        work `catches` [Handler (reply . busRequestErrorMessage), Handler (reply . transportErrorMessage)]
  pure (MatchStateUnit tasks)

dispose :: MatchStateUnit -> IO ()
dispose (MatchStateUnit tasks) = Tasks.dispose tasks
