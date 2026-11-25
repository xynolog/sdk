module Xynolog.Bind (BindNamespace, newBind, body, initiate, reportBodyError) where

import Control.Concurrent.STM (STM)
import Xynolog.Bus qualified as Bus
import Xynolog.Channels
import Xynolog.EventBus (EventBus)
import Xynolog.Internal.Local qualified as Local
import Xynolog.Timing.Settings qualified as Timing
import Xynolog.Types

data BindNamespace = BindNamespace Bus.Bus EventBus Timing.Settings

newBind :: Bus.Bus -> EventBus -> Timing.Settings -> BindNamespace
newBind = BindNamespace

body :: BindNamespace -> ResourceId -> AnnotationId -> [BindBodyOperation] -> IO BindBodyUpdated
body (BindNamespace wire _ timing) resource annotation operations =
  Bus.request wire BindUpdateBodyOperation (BindUpdateBodyCommand Nothing annotation operations resource) (Timing.busRequestTimeoutMs timing)

initiate :: BindNamespace -> BindInitiateCommand -> STM ()
initiate (BindNamespace _ bus _) input = Local.signal bus BindInitiate input NoScope

reportBodyError :: BindNamespace -> ResourceErrorEvent -> STM ()
reportBodyError (BindNamespace _ bus _) input = Local.signal bus BindBodyError input NoScope
