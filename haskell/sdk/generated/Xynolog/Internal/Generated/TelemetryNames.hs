-- Generated from sdk-telemetry/telemetry.json; do not edit.
-- Regenerate: make generate (codegen/lib/telemetry/telemetry.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.TelemetryNames (telemetryChannel, spanBusEmit, spanBusRecv, spanContentPut, spanContentGet, spanContentGetGraph, spanContentGetAnchoredText, spanContentGetAnnotations, metricXynologBusSent) where

import Data.Text (Text)

-- | What stands for the bus channel in a span's name.
telemetryChannel :: Text
telemetryChannel = "{channel}"

-- | A frame the client sent, in the trace of the work that sent it.
spanBusEmit :: Text
spanBusEmit = "bus.emit:{channel}"

-- | A frame the client received, and the work done for it, in the trace the
-- frame was sent under.
spanBusRecv :: Text
spanBusRecv = "bus.recv:{channel}"

-- | An upload.
spanContentPut :: Text
spanContentPut = "content.put"

-- | A read of a resource's bytes.
spanContentGet :: Text
spanContentGet = "content.get"

-- | A read of a resource's description.
spanContentGetGraph :: Text
spanContentGetGraph = "content.get_graph"

-- | A read of a resource's anchored text.
spanContentGetAnchoredText :: Text
spanContentGetAnchoredText = "content.get_anchored_text"

-- | A read of a resource's annotations.
spanContentGetAnnotations :: Text
spanContentGetAnnotations = "content.get_annotations"

-- | Emits the client sent.
metricXynologBusSent :: Text
metricXynologBusSent = "xynolog.bus.sent"
