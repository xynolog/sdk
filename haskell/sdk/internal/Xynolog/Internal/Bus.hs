{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Bus
  ( Bus (..),
    BusOptions (..),
    newBus,
    emit,
    frames,
    request,
    requestDelivered,
    Delivered (..),
    FrameRefusal (..),
    Heard (..),
    Carried (..),
    Fault (..),
    decoded,
    replyChannelsFor,
    unsubscribed,
    persistedEventTypes,
  )
where

import Control.Concurrent.Async (race)
import Control.Concurrent.STM
import Control.Exception (bracket, throwIO)
import Control.Monad (forM_, unless, when)
import Data.Aeson (Result (..), Value (..), fromJSON)
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.List (nub)
import Data.Set qualified as Set
import Data.Text (Text)
import Data.Text qualified as Text
import OpenTelemetry.Context.ThreadLocal.Propagation (propagateContext)
import Streaming (Of, Stream)
import Streaming.Prelude qualified as Stream
import Xynolog.Channels
import Xynolog.ErrorCodes hiding (TransportError)
import Xynolog.ErrorCodes qualified as Codes
import Xynolog.Errors
import Xynolog.Internal.Generated.OperationFailure qualified as OperationFailure
import Xynolog.Internal.Required (Fault (..))
import Xynolog.Internal.Required qualified as Required
import Xynolog.Internal.StateValue qualified as State
import Xynolog.Internal.Transport (Carried (..), FrameRefusal (..))
import Xynolog.Internal.Transport qualified as Transport
import Xynolog.Transport.Facts (userField)
import Xynolog.Types (BusFrame (..), BusFramePayload (..), ConnectionState (..), FrameRefusalReason (..), ResourceId, UserId)

data BusOptions = BusOptions
  { -- | Monotonic nanoseconds in the wait's coordinate system.
    requestNow :: IO Integer,
    -- | Interruptible wait to an absolute monotonic nanosecond deadline.
    requestWaitUntil :: Integer -> IO (),
    -- | A fresh unique id for every request on the transport, including settled requests.
    nextCorrelationId :: IO Text
  }

data Bus = Bus BusOptions Transport.Transport

data Delivered payload = Delivered
  { deliveredPayload :: payload,
    deliveredFrame :: Transport.Frame,
    emittedBy :: Maybe UserId
  }
  deriving (Eq, Show)

data Heard payload = Heard (Delivered payload) | Refused FrameRefusal deriving (Eq, Show)

newBus :: BusOptions -> Transport.Transport -> Bus
newBus = Bus

scopeValue :: ScopeArg scope -> Maybe ResourceId
scopeValue NoScope = Nothing
scopeValue (InScope resource) = Just resource

emit :: Bus -> Channel scope payload -> payload -> ScopeArg scope -> Maybe Text -> IO (Maybe Integer)
emit (Bus _ transport) channel payload scope correlation = case encodePayload channel payload of
  Object fields -> case decodePayload channel (Object fields) of
    Left _ -> Transport.raiseTransportError transport (TransportError Codes.TransportError "outgoing payload is not its channel's" Nothing Nothing)
    Right _ -> Transport.emit transport (BusFrame (channelName channel) correlation (BusFramePayload fields) (scopeValue scope))
  _ -> Transport.raiseTransportError transport (TransportError Codes.TransportError "channel payload is not an object" Nothing Nothing)

decoded :: Channel scope payload -> Transport.Carried -> Heard payload
decoded _ (Transport.FrameRejected refusal) = Refused refusal
decoded channel (Transport.Arrived frame) =
  let raw = busFramePayloadAdditionalProperties (busFramePayload (Transport.wireFrame frame))
      identity = case KM.lookup (Key.fromText userField) raw of
        Nothing -> Right Nothing
        Just value -> case fromJSON value of Success user -> Right (Just user); Error _ -> Left ()
   in case (decodePayload channel (Object raw), identity) of
        (Right payload, Right user) -> Heard (Delivered payload frame user)
        _ ->
          let issue = case Required.faultChannel (channelName channel) (Object raw) of
                Just value -> value
                Nothing -> case identity of Left () -> Fault userField FrameRefusalReasonMalformed; Right _ -> Required.undecoded
              way = if Required.member issue == "" then "payload" else "payload." <> Required.member issue
           in Refused
                ( FrameRefusal
                    (channelName channel)
                    (Just (Object raw))
                    (busFrameScope (Transport.wireFrame frame))
                    (busFrameCorrelationId (Transport.wireFrame frame))
                    (issue {Required.member = way})
                )

frames :: Bus -> Channel scope payload -> ScopeArg scope -> (Stream (Of (Heard payload)) IO () -> IO result) -> IO result
frames (Bus _ transport) channel scope consume = Transport.frames transport (channelName channel) $ \wire ->
  let values = Stream.map (decoded channel) (Stream.filter (\frame -> maybe True (\resource -> Transport.carriedScope frame == Just resource) (scopeValue scope)) wire)
   in case scope of
        NoScope -> consume values
        InScope resource -> bracket (Transport.subscribeToResource transport resource) id (const (consume values))

unsubscribed :: Text -> BusRequestError
unsubscribed channel = BusRequestError BusRequestUnsubscribed ("transport does not receive " <> channel) Nothing

replyChannelsFor :: [SomeOperation] -> [Text]
replyChannelsFor operations = nub (concatMap names operations)
  where
    names (SomeOperation operation) = let (_, result, failure) = operationChannels operation in [channelName result, channelName failure]

request :: Bus -> Operation input output failure -> input -> Integer -> IO output
request bus operation input timeoutMs = deliveredPayload <$> requestDelivered bus operation input timeoutMs

payloadRefusalSaid :: FrameRefusal -> Text
payloadRefusalSaid refusal =
  "a payload on "
    <> refusedChannel refusal
    <> " is not that channel's: "
    <> Required.faultSaid ((fault refusal) {Required.member = if Required.member (fault refusal) == "payload" then "" else Text.drop 8 (Required.member (fault refusal))})

-- A refused reply is told to the request awaiting it and to no one else: the
-- transport's failure report is for a refused frame that names no reader.
requestDelivered :: Bus -> Operation input output failure -> input -> Integer -> IO (Delivered output)
requestDelivered bus@(Bus options transport) operation input timeoutMs = do
  let (asked, result, failure) = operationChannels operation
      replyChannels = [channelName result, channelName failure]
      timedOut = throwIO (BusRequestError BusRequestTimeout "bus request deadline expired" Nothing)
  forM_ replyChannels $ \channel -> unless (Transport.isSubscribed transport channel) (throwIO (unsubscribed channel))
  connectionBefore <- atomically (State.current (Transport.state transport))
  when (connectionBefore == ConnectionStateClosed) (throwIO (BusRequestError BusRequestClosed "transport is closed" Nothing))
  now <- requestNow options
  when (timeoutMs <= 0) timedOut
  let work = do
        atomically $ do
          connection <- State.current (Transport.state transport)
          case connection of
            ConnectionStateOpen -> pure ()
            ConnectionStateClosed -> throwSTM (BusRequestError BusRequestClosed "transport closed before emit" Nothing)
            _ -> retry
        correlation <- nextCorrelationId options
        Transport.withPendingReply transport correlation (Set.fromList replyChannels) $ \awaitReply -> do
          _ <- emit bus asked input NoScope (Just correlation)
          reply <- atomically awaitReply
          carried <- maybe (throwIO (BusRequestError BusRequestClosed "transport closed before reply" Nothing)) pure reply
          frame <- case carried of
            Transport.Arrived value -> pure value
            Transport.FrameRejected refusal ->
              throwIO
                (TransportError Codes.TransportError (Transport.refusalSaid refusal) Nothing Nothing)
          if busFrameChannel (Transport.wireFrame frame) == channelName result
            then case decoded result (Transport.Arrived frame) of
              Heard delivered -> pure delivered
              Refused refusal ->
                throwIO
                  ( TransportError
                      Codes.TransportError
                      (payloadRefusalSaid refusal)
                      Nothing
                      Nothing
                  )
            else do
              -- A failure is held to its channel's shape before it is read, as a result is: one with a
              -- fault is refused, naming the fault, and one without words is never given any. The
              -- request fails with the failure as read, a code the wire does not list left out, with
              -- the code and words of the operation's typed failure.
              let fields = busFramePayloadAdditionalProperties (busFramePayload (Transport.wireFrame frame))
                  refuse issue =
                    throwIO
                      ( TransportError
                          Codes.TransportError
                          ("a payload on " <> channelName failure <> " is not that channel's: " <> Required.faultSaid issue)
                          Nothing
                          Nothing
                      )
              case Required.faultChannel (channelName failure) (Object fields) of
                Just issue -> refuse issue
                Nothing -> case decoded failure (Transport.Arrived frame) of
                  Refused _ -> refuse Required.undecoded
                  Heard delivered ->
                    throwIO
                      ( BusRequestError
                          (OperationFailure.code operation (deliveredPayload delivered))
                          (OperationFailure.message operation (deliveredPayload delivered))
                          (Just (Required.channelRead (channelName failure) fields))
                      )
  inheritedWork <- propagateContext work
  inheritedWait <- propagateContext (requestWaitUntil options (now + timeoutMs * 1000000))
  outcome <-
    race
      inheritedWork
      ( race
          inheritedWait
          (atomically (State.current (Transport.state transport) >>= check . (== ConnectionStateClosed)))
      )
  case outcome of
    Left value -> pure value
    Right (Left ()) -> timedOut
    Right (Right ()) -> throwIO (BusRequestError BusRequestClosed "transport closed during request" Nothing)
