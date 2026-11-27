{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Telemetry (withSpan, withUpload, sending, withReceived, traceCarrier, outgoingHeaders) where

import Control.Exception (bracket, finally)
import Data.Aeson (Result (..), Value (..), fromJSON, toJSON)
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.CaseInsensitive qualified as CI
import Data.HashMap.Strict qualified as HashMap
import Data.Int (Int64)
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.Encoding (encodeUtf8)
import Data.Version (showVersion)
import Network.HTTP.Types (RequestHeaders)
import OpenTelemetry.Attributes (Attribute, toAttribute)
import OpenTelemetry.Attributes qualified as Attributes
import OpenTelemetry.Context.ThreadLocal (attachContext, detachContext, getContext)
import OpenTelemetry.Metric.Core qualified as Metric
import OpenTelemetry.Propagator qualified as Propagator
import OpenTelemetry.Trace.Core qualified as Trace
import Paths_xynolog (version)
import Xynolog.Internal.Generated.TelemetryKeys (attributeBusChannel, attributeBusScope, attributeContentFormat, attributeContentSizeBytes)
import Xynolog.Internal.Generated.TelemetryNames (metricXynologBusSent, spanBusEmit, spanBusRecv, spanContentPut, telemetryChannel)
import Xynolog.Internal.Required (faultOf)
import Xynolog.Transport.Facts (traceField)
import Xynolog.Types

scope :: Trace.InstrumentationLibrary
scope = Trace.instrumentationLibrary "xynolog" (Text.pack (showVersion version))

-- The shared wire telemetry corpus holds these calls to every declared span,
-- kind and attribute in protocol/specs/src/sdk-telemetry/telemetry.json.
withSpan :: Trace.SpanKind -> Text -> [(Text, Attribute)] -> IO result -> IO result
withSpan kind name attributes action = do
  provider <- Trace.getGlobalTracerProvider
  tracer <- Trace.getTracer provider scope Trace.tracerOptions
  Trace.inSpan''
    tracer
    name
    Trace.defaultSpanArguments
      { Trace.kind = kind,
        Trace.attributes = HashMap.fromList attributes
      }
    (const action)

withUpload :: Text -> IO Integer -> IO result -> IO result
withUpload format size action = do
  provider <- Trace.getGlobalTracerProvider
  tracer <- Trace.getTracer provider scope Trace.tracerOptions
  Trace.inSpan''
    tracer
    spanContentPut
    Trace.defaultSpanArguments
      { Trace.kind = Trace.Client,
        Trace.attributes = HashMap.singleton attributeContentFormat (toAttribute format)
      }
    $ \activeSpan ->
      action `finally` (size >>= Trace.addAttribute activeSpan attributeContentSizeBytes . sizeAttribute)
  where
    sizeAttribute value
      | value >= toInteger (minBound :: Int64) && value <= toInteger (maxBound :: Int64) = toAttribute (fromInteger value :: Int64)
      | otherwise = toAttribute (Text.pack (show value))

sending :: BusFrame -> IO result -> IO result
sending frame action = do
  sent frame
  withSpan Trace.Producer (Text.replace telemetryChannel (busFrameChannel frame) spanBusEmit) (busAttributes frame) action

sent :: BusFrame -> IO ()
sent frame = do
  provider <- Metric.getGlobalMeterProvider
  meter <- Metric.getMeter provider scope
  counter <- Metric.meterCreateCounterInt64 meter metricXynologBusSent Nothing Nothing Metric.defaultAdvisoryParameters
  Metric.counterAdd counter 1 (Attributes.addAttributes Attributes.defaultAttributeLimits Attributes.emptyAttributes (HashMap.fromList (busAttributes frame)))

busAttributes :: BusFrame -> [(Text, Attribute)]
busAttributes frame =
  (attributeBusChannel, toAttribute (busFrameChannel frame))
    : maybe [] (\resource -> [(attributeBusScope, toAttribute (resourceIdValue resource))]) (busFrameScope frame)

withReceived :: BusFrame -> IO result -> IO result
withReceived frame action = do
  parent <- getContext
  propagator <- Propagator.getGlobalTextMapPropagator
  let fields = busFramePayloadAdditionalProperties (busFramePayload frame)
      carrier = case toJSON <$> (KM.lookup (Key.fromText traceField) fields >>= traceCarrier) of
        Just (Object values) -> Propagator.textMapFromList [(Key.toText key, value) | (key, String value) <- KM.toList values]
        _ -> Propagator.emptyTextMap
  context <- Propagator.extract propagator carrier parent
  bracket (attachContext context) detachContext $ \_ ->
    withSpan Trace.Consumer (Text.replace telemetryChannel (busFrameChannel frame) spanBusRecv) (busAttributes frame) action

-- | A relayed frame's trace field, read by the required table and then as its
-- generated type: a value either refuses carries no trace.
traceCarrier :: Value -> Maybe TraceCarrier
traceCarrier value = case faultOf "TraceCarrier" value of
  Just _ -> Nothing
  Nothing -> case fromJSON value of Success carrier -> Just carrier; Error _ -> Nothing

outgoingHeaders :: IO RequestHeaders
outgoingHeaders = do
  propagator <- Propagator.getGlobalTextMapPropagator
  context <- getContext
  injected <- Propagator.inject propagator context Propagator.emptyTextMap
  pure [(CI.mk (encodeUtf8 key), encodeUtf8 value) | (key, value) <- Propagator.textMapToList injected]
