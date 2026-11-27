{-# LANGUAGE OverloadedStrings #-}

module Valid where

import Data.Text (Text)
import qualified Data.Text.IO as Text
import qualified Xynolog.Bus as Bus
import qualified Xynolog.Channels as Channels
import Xynolog.Discovery (readDiscovery, textDiscovery)
import qualified Xynolog.Timing as Timing
import Xynolog.Types (DiscoveryRead, EmptyBusPayload, FrameAddEntityTypeCommand, ResourceId, mkResourceId)

identifier :: Either String ResourceId
identifier = mkResourceId "probe"

channel :: Text
channel = Channels.channelName Channels.BrowseResourceRequested

discover :: FilePath -> IO DiscoveryRead
discover path = readDiscovery (textDiscovery (Text.readFile path))

ask :: Bus.Bus -> FrameAddEntityTypeCommand -> IO EmptyBusPayload
ask bus payload = Bus.request bus Channels.FrameAddEntityTypeOperation payload Timing.busRequestTimeoutMs

observe :: Bus.Bus -> ResourceId -> IO ()
observe bus resource = Bus.frames bus Channels.MarkAdded (Channels.InScope resource) (const (pure ()))
