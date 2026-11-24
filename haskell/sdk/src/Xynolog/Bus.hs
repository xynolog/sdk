module Xynolog.Bus
  ( Bus,
    BusOptions (..),
    newBus,
    emit,
    frames,
    request,
    Delivered (..),
    FrameRefusal (..),
    Heard (..),
    Carried (..),
    Fault (..),
    FrameRefusalReason (..),
    replyChannelsFor,
    unsubscribed,
    persistedEventTypes,
  )
where

import Xynolog.Internal.Bus
import Xynolog.Types (FrameRefusalReason (..))
