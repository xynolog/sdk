module Xynolog.Frame (FrameNamespace, newFrame, addEntityType, addEntityTypes, addTagSchema) where

import Data.Text (Text)
import Xynolog.Bus qualified as Bus
import Xynolog.Channels
import Xynolog.Timing.Settings qualified as Timing
import Xynolog.Types

data FrameNamespace = FrameNamespace Bus.Bus Timing.ClientTiming

newFrame :: Bus.Bus -> Timing.ClientTiming -> FrameNamespace
newFrame = FrameNamespace

addEntityType :: FrameNamespace -> Text -> IO EmptyBusPayload
addEntityType (FrameNamespace bus timing) tag = Bus.request bus FrameAddEntityTypeOperation (FrameAddEntityTypeCommand {frameAddEntityTypeCommandUserId = Nothing, frameAddEntityTypeCommandTag = tag}) (Timing.busRequestTimeoutMs timing)

addEntityTypes :: FrameNamespace -> [Text] -> IO [EmptyBusPayload]
addEntityTypes namespace = mapM (addEntityType namespace)

addTagSchema :: FrameNamespace -> TagSchema -> IO EmptyBusPayload
addTagSchema (FrameNamespace bus timing) schema = Bus.request bus FrameAddTagSchemaOperation (FrameAddTagSchemaCommand {frameAddTagSchemaCommandUserId = Nothing, frameAddTagSchemaCommandSchema = schema}) (Timing.busRequestTimeoutMs timing)
