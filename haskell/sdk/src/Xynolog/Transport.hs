-- | A common runtime for wire and in-process carriers. The input handle belongs
-- to the carrier; consumers receive the transport and read-only observations.
module Xynolog.Transport
  ( Transport,
    TransportInput,
    TransportOptions (..),
    Frame (..),
    Carried (..),
    FrameRefusal (..),
    carriedChannel,
    carriedScope,
    carriedCorrelationId,
    refusalSaid,
    newTransport,
    baseUrl,
    emit,
    frames,
    stream,
    on,
    state,
    errors,
    isSubscribed,
    subscribeToResource,
    trackReply,
    bridgeInto,
    dispose,
    receive,
    receiveRefusal,
    setState,
    subscriptions,
    reportError,
    ConnectionState (..),
    connectionStateText,
    connectionTransitions,
  )
where

import Xynolog.Internal.Transport
import Xynolog.Transport.Facts
import Xynolog.Types (ConnectionState (..), connectionStateText)
