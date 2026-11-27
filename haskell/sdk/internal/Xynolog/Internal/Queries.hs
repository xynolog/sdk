module Xynolog.Internal.Queries (cacheOptions, oneReport) where

import Xynolog.Bus qualified as Bus
import Xynolog.Internal.Cache qualified as Cache
import Xynolog.Internal.Running qualified as Running

cacheOptions :: Bus.BusOptions -> (key -> IO (IO ())) -> Cache.CacheOptions key value
cacheOptions clock scope =
  Cache.CacheOptions
    (Bus.requestNow clock)
    (Bus.requestWaitUntil clock)
    Nothing
    scope

oneReport :: IO value -> IO (Running.Running value value)
oneReport action = Running.newRunning $ \report -> do
  value <- action
  report value
  pure value
