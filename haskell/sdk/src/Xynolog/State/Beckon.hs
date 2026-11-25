{-# LANGUAGE OverloadedStrings #-}

-- | Attention for one resource, heard on the client's own signal plane.
module Xynolog.State.Beckon (BeckonStateUnit, newBeckonStateUnit, hoveredAnnotationId, focus, dispose) where

import Control.Concurrent.STM
import Control.Exception (finally)
import Control.Monad (unless)
import Data.Aeson (Value (..))
import Xynolog.Channels
import Xynolog.Client qualified as Client
import Xynolog.Internal.Local qualified as Local
import Xynolog.Internal.StateTasks qualified as Tasks
import Xynolog.Internal.StateValue qualified as State
import Xynolog.Internal.Transport qualified as Transport
import Xynolog.Types

data BeckonStateUnit = BeckonStateUnit Tasks.Tasks Client.Client ResourceId (State.StateValue (Maybe AnnotationId))

newBeckonStateUnit :: Client.Client -> ResourceId -> IO BeckonStateUnit
newBeckonStateUnit client resource = do
  tasks <- Tasks.newTasks "beckon state unit is closed"
  unit <- BeckonStateUnit tasks client resource <$> atomically (State.newStateValue Nothing)
  Tasks.listen tasks (Client.bus client) [channelName BeckonHover, channelName BrowseClick] $ \frame -> do
    let envelope = Transport.wireFrame frame
        payload = Object (busFramePayloadAdditionalProperties (busFramePayload envelope))
    if busFrameChannel envelope == channelName BeckonHover
      then case decodePayload BeckonHover payload of
        Left _ -> pure ()
        Right value -> atomically $ do
          let annotation = beckonHoverEventAnnotationId value
          State.update (hoveredAnnotationId unit) annotation
          mapM_ (\identity -> Local.signal (Client.bus client) BeckonSparkle (BeckonSparkleEvent identity) NoScope) annotation
      else case decodePayload BrowseClick payload of
        Left _ -> pure ()
        Right value -> focus unit (browseClickEventAnnotationId value)
  pure unit

hoveredAnnotationId :: BeckonStateUnit -> State.StateValue (Maybe AnnotationId)
hoveredAnnotationId (BeckonStateUnit _ _ _ value) = value

focus :: BeckonStateUnit -> AnnotationId -> IO ()
focus (BeckonStateUnit tasks client resource _) identity = atomically $ do
  over <- Tasks.closed tasks
  unless over (Local.signal (Client.bus client) BeckonFocus (BeckonFocusEvent (Just identity) resource) NoScope)

dispose :: BeckonStateUnit -> IO ()
dispose unit@(BeckonStateUnit tasks _ _ _) = Tasks.dispose tasks `finally` atomically (State.complete (hoveredAnnotationId unit))
