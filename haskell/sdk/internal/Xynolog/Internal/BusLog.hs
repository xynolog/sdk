{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.BusLog (Logger (..), environmentLogger, shown, frame, content) where

import Data.Aeson (Value (..), encode)
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString qualified as Bytes
import Data.ByteString.Lazy qualified as Lazy
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.Encoding (decodeUtf8, encodeUtf8)
import OpenTelemetry.Context qualified as Context
import OpenTelemetry.Context.ThreadLocal (getContext)
import OpenTelemetry.Trace.Core qualified as Trace
import OpenTelemetry.Trace.Id qualified as TraceId
import System.Environment (lookupEnv)
import System.IO (hFlush, stderr)
import Xynolog.Internal.Generated.BusLog qualified as Policy
import Xynolog.ServiceEnvironment (xynologBusLog)
import Xynolog.Types

-- The existing cross-SDK switch is read at the HTTP owner's creation. It is
-- the only process environment consulted by this SDK.
data Logger = Logger Bool (Text -> IO ())

environmentLogger :: IO Logger
environmentLogger = do
  setting <- lookupEnv xynologBusLog
  pure (Logger (maybe False (not . null) setting) (\written -> Bytes.hPut stderr (encodeUtf8 (written <> "\n")) >> hFlush stderr))

shown :: Value -> Value
shown (Object fields) = Object (KM.mapWithKey (\key value -> if Key.toText key `elem` Policy.withheldNames then String "[withheld]" else shown value) fields)
shown (Array values) = Array (fmap shown values)
shown value = value

line :: Logger -> Text -> Text -> Maybe ResourceId -> Maybe Text -> Value -> IO ()
line (Logger False _) _ _ _ _ _ = pure ()
line (Logger True write) op channel scope correlation payload = do
  active <- Context.lookupSpan <$> getContext >>= traverse Trace.getSpanContext
  let trace =
        active >>= \context ->
          let identity = Trace.traceId context
           in if TraceId.isEmptyTraceId identity then Nothing else Just (Text.take 8 (TraceId.traceIdBaseEncodedText TraceId.Base16 identity))
  write
    ( "[bus "
        <> op
        <> "] "
        <> channel
        <> maybe "" ((" scope=" <>) . resourceIdValue) scope
        <> maybe "" ((" cid=" <>) . Text.take 8) correlation
        <> maybe "" (" trace=" <>) trace
        <> " "
        <> decodeUtf8 (Lazy.toStrict (encode (shown payload)))
    )

frame :: Logger -> Text -> BusFrame -> IO ()
frame logger op value =
  line
    logger
    op
    (busFrameChannel value)
    (busFrameScope value)
    (busFrameCorrelationId value)
    (Object (busFramePayloadAdditionalProperties (busFramePayload value)))

content :: Logger -> Text -> Value -> IO ()
content logger op = line logger op "content" Nothing Nothing
