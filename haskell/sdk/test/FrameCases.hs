{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module FrameCases (frameCases) where

import Control.Applicative ((<|>))
import Control.Concurrent.Async (wait, withAsync)
import Control.Concurrent.STM
import Control.Exception (SomeException, bracket, fromException, try)
import Control.Monad (forM_, unless, when)
import Data.Aeson (Result (..), ToJSON, Value (..), eitherDecodeStrict', encode, fromJSON, toJSON)
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString qualified as Bytes
import Data.ByteString.Lazy qualified as Lazy
import Data.Foldable (toList)
import Data.Set qualified as Set
import Data.Text (Text)
import Data.Text.Encoding (decodeUtf8)
import Streaming.Prelude qualified as Stream
import System.FilePath ((</>))
import System.Timeout (timeout)
import Xynolog.Bus qualified as Bus
import Xynolog.Channels hiding (BrowseResourceResult)
import Xynolog.Channels qualified as Channel
import Xynolog.ErrorCodes qualified as Code
import Xynolog.Errors (BusRequestError (..), TransportError (..))
import Xynolog.Internal.Required qualified as Required
import Xynolog.Internal.StreamFrame qualified as Frame
import Xynolog.Transport qualified as Transport
import Xynolog.Types

require :: String -> Bool -> IO ()
require label value = unless value (ioError (userError label))

frameCases :: FilePath -> IO ()
frameCases root = do
  result <- timeout 5000000 (runCases root)
  require "frame cases did not settle their readers and requests" (result == Just ())
  putStrLn "PASS every shared stream frame, typed refusal, typed read, destination and pending-request case"

-- | What a case may state.
caseKeys :: [Text]
caseKeys = ["why", "frame", "data", "read", "refused", "member", "reason", "told", "correlationId", "request"]

-- | A transport over no wire that receives every channel and puts asked when it sends, and a bus over it whose clock
-- moves only when the runner moves it.
withBus :: (TMVar () -> TVar Integer -> Transport.Transport -> Transport.TransportInput -> Bus.Bus -> IO result) -> IO result
withBus action = do
  asked <- newEmptyTMVarIO
  bracket
    ( Transport.newTransport
        ( Transport.TransportOptions
            "local://frame-cases"
            (Set.fromList channelNames)
            (\_ -> atomically (putTMVar asked ()) >> pure Nothing)
            (pure ())
        )
    )
    (Transport.dispose . fst)
    $ \(transport, input) -> do
      Transport.setState input Transport.ConnectionStateConnecting
      Transport.setState input Transport.ConnectionStateOpen
      clock <- newTVarIO 0
      let bus =
            Bus.newBus
              ( Bus.BusOptions
                  (readTVarIO clock)
                  (\deadline -> atomically (readTVar clock >>= check . (>= deadline)))
                  (pure "c-1")
              )
              transport
      action asked clock transport input bus

-- | What a delivered frame's typed reader reads of its payload, or nothing when it refuses the frame.
typedRead :: (ToJSON payload) => Channel 'Global payload -> BusFrame -> IO (Maybe Value)
typedRead channel frame = withBus $ \_ _ _ input bus -> Bus.frames bus channel NoScope $ \values -> do
  Transport.receive input frame
  heard <- Stream.head_ values
  pure (case heard of Just (Bus.Heard delivered) -> Just (toJSON (Bus.deliveredPayload delivered)); _ -> Nothing)

runCases :: FilePath -> IO ()
runCases root = do
  table <- Bytes.readFile (root </> "protocol/specs/src/bus/frame-cases.json") >>= either (ioError . userError) pure . eitherDecodeStrict'
  let member key (Object fields) = maybe (error ("missing frame case member " ++ show key)) id (KM.lookup key fields)
      member _ _ = error "frame case is not an object"
      rows = case member "cases" table of Array values -> toList values; _ -> error "frame cases is not an array"
  forM_ rows $ \row -> do
    fields <- case row of Object fields -> pure fields; _ -> ioError (userError "frame row is not an object")
    require ("a frame case states what its runner does not know: " ++ show row) (all ((`elem` caseKeys) . Key.toText) (KM.keys fields))
    text <- case (KM.lookup "data" fields, KM.lookup "frame" fields) of
      (Just (String raw), Nothing) -> pure raw
      (Nothing, Just raw) -> pure (decodeUtf8 (Lazy.toStrict (encode raw)))
      _ -> ioError (userError "frame case must state frame or data")
    let parsed = Frame.readFrame text
        expectedRefusal = KM.lookup "refused" fields == Just (Bool True)
        verify told issue = do
          require "a valid stream frame was refused" expectedRefusal
          require "a frame refusal named the wrong member" (String (Bus.faultMember issue) == member "member" row)
          require "a frame refusal named the wrong reason" (toJSON (Bus.faultReason issue) == member "reason" row)
          require "a frame refusal found the wrong reader" (String told == member "told" row)
        publish input = case parsed of
          Frame.Accepted frame -> Transport.receive input frame
          Frame.Refused refusal -> Transport.receiveRefusal input refusal
          Frame.Rejected _ -> ioError (userError "unnamed frame routed to readers")
    case parsed of
      Frame.Rejected issue -> verify "failure-report" issue
      Frame.Accepted frame | not expectedRefusal -> do
        require "a stream frame changed on reading" (toJSON frame == member "frame" row)
        let channel = busFrameChannel frame
            stated = KM.lookup "read" fields <|> (case member "frame" row of Object raw -> KM.lookup "payload" raw; _ -> Nothing)
        reading <-
          if channel == channelName Channel.BrowseResourceFailed
            then Just <$> typedRead Channel.BrowseResourceFailed frame
            else
              if channel == channelName Channel.GatherFailed
                then Just <$> typedRead Channel.GatherFailed frame
                else pure Nothing
        case reading of
          Just found -> require ("a typed reader read otherwise than the case states: " ++ show (row, found)) (found == stated)
          Nothing -> require "a frame case states a typed read on a channel its runner reads by no type" (not (KM.member "read" fields))
      _ -> withBus $ \asked clock transport input bus -> do
        let raw = member "frame" row
            channel = member "channel" raw
            inspect values = do
              publish input
              heard <- Stream.head_ values
              refusal <- case heard of Just (Bus.Refused value) -> pure value; _ -> ioError (userError "typed reader lost a refused frame")
              verify "readers" (Bus.Fault (Bus.frameRefusalMember refusal) (Bus.frameRefusalReason refusal))
              require "refusal lost its raw payload" (Transport.frameRefusalPayload refusal == (case raw of Object value -> KM.lookup "payload" value; _ -> Nothing))
              require "refusal carried the wrong correlation id" (fmap String (Transport.frameRefusalCorrelationId refusal) == KM.lookup "correlationId" fields)
        if channel == String (channelName BeckonFocus)
          then Bus.frames bus BeckonFocus NoScope inspect
          else
            if channel == String (channelName Channel.BrowseResourceResult)
              then Bus.frames bus Channel.BrowseResourceResult NoScope inspect
              else ioError (userError "unread typed channel in frame cases")
        forM_ (KM.lookup "request" fields) $ \expected -> Transport.errors transport $ \observations -> do
          resource <- either (ioError . userError) pure (mkResourceId "res-1")
          let action =
                try (Bus.request bus BrowseResourceRequestedOperation (BrowseResourceRequest resource) 100) ::
                  IO (Either SomeException BrowseResourceResult)
          withAsync action $ \pending -> do
            atomically (takeTMVar asked)
            publish input
            when (expected == String "waits") (atomically (writeTVar clock 100000000))
            answer <- wait pending
            case (expected, answer) of
              (String "fails", Left problem) | Just failure <- fromException problem -> do
                let issue =
                      Bus.Fault
                        (case member "member" row of String value -> value; _ -> error "nontext fault")
                        (case fromJSON (member "reason" row) of Success reason -> reason; Error unread -> error unread)
                require
                  "request did not fail with its frame refusal"
                  ( failure
                      == TransportError
                        Code.TransportError
                        ("a frame on browse:resource-result is not that channel's: " <> Required.faultSaid issue)
                        Nothing
                        Nothing
                  )
              (String "waits", Left problem)
                | Just failure <- fromException problem ->
                    require "a reply without a readable correlation id reached the request" (busRequestErrorCode failure == Code.BusRequestTimeout)
              _ -> ioError (userError "unread request outcome in frame cases")
          -- A refusal told to its readers is told to no failure report: the report's first
          -- observation is a marker reported after the request settled.
          let marker = TransportError Code.TransportError "reported after the request settled" Nothing Nothing
          Transport.reportError input marker
          noticed <- Stream.toList_ (Stream.take 1 observations)
          require "a refused reply reached the transport's failure report" (noticed == [marker])
