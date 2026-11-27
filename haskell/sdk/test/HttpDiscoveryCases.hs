{-# LANGUAGE OverloadedStrings #-}

module HttpDiscoveryCases (httpDiscoveryCases) where

import Control.Concurrent.Async (async, cancel, poll, wait)
import Control.Concurrent.STM
import Control.Exception (AsyncException (UserInterrupt), throwIO, try)
import Control.Monad (forM_, unless)
import ControlledTime qualified as Time
import Data.Aeson (encode)
import Data.ByteString qualified as Bytes
import Data.ByteString.Char8 qualified as Char8
import Data.ByteString.Lazy qualified as Lazy
import IssuerCases (httpPeer, route)
import Xynolog.Discovery qualified as D
import Xynolog.Http.Discovery qualified as Http
import Xynolog.Retry qualified as Retry
import Xynolog.Timing qualified as Timing
import Xynolog.Timing.Settings qualified as Settings
import Xynolog.Types
  ( DiscoveryAbsent (..),
    DiscoveryAbsentReason (..),
    DiscoveryDocument (..),
    DiscoveryManaged (..),
    DiscoveryManagedKind (..),
    DiscoveryRead (..),
    DiscoveryUnchanged (..),
    DiscoveryUnchangedKind (..),
  )

require :: String -> Bool -> IO ()
require label good = unless good (ioError (userError label))

reply :: Int -> [(Bytes.ByteString, Bytes.ByteString)] -> Bytes.ByteString -> Bytes.ByteString
reply code headers body =
  "HTTP/1.1 "
    <> Char8.pack (show code)
    <> " reply\r\nConnection: close\r\nContent-Length: "
    <> Char8.pack (show (Bytes.length body))
    <> "\r\n"
    <> Bytes.concat [key <> ": " <> value <> "\r\n" | (key, value) <- headers]
    <> "\r\n"
    <> body

httpDiscoveryCases :: DiscoveryDocument -> IO ()
httpDiscoveryCases document = do
  time <- Time.newTime
  requests <- newTVarIO []
  response <- newTVarIO (reply 200 [("Content-Type", "application/json"), ("ETag", "\"one\"")] (Lazy.toStrict (encode document)))
  let options = Retry.RetryOptions (Time.now time) (Time.waitUntil time) (pure 0)
      make client = Http.httpDiscovery client options Settings.protocolTransportTiming "http://launcher.test/discovery"
      set bytes = atomically (writeTVar response bytes)
      asks = readTVarIO requests
      latest = asks >>= \seen -> case seen of value : _ -> pure value; _ -> ioError (userError "no discovery request")
      reason expected readValue = case readValue of DiscoveryReadDiscoveryAbsent found -> discoveryAbsentReason found == expected; _ -> False
  client <- httpPeer $ \request -> do
    atomically (modifyTVar' requests (request :))
    if route request == "/redirect" then pure (reply 302 [("Location", "/discovery")] "") else readTVarIO response
  transport <- make client
  initial <- D.readDiscovery transport
  require "HTTP discovery lost its whole managed document" (initial == DiscoveryReadDiscoveryManaged (DiscoveryManaged DiscoveryManagedKindManaged (discoveryDocumentKbs document)))
  require "first discovery request carried a tag" . not . Bytes.isInfixOf "If-None-Match:" =<< latest
  set (reply 304 [] "")
  require "conditional discovery did not retain the previous document" . (== DiscoveryReadDiscoveryUnchanged (DiscoveryUnchanged DiscoveryUnchangedKindUnchanged)) =<< D.readDiscovery transport
  require "conditional discovery did not send the last good tag" . Bytes.isInfixOf "If-None-Match: \"one\"" =<< latest
  forM_
    [ (404, [("Content-Type", "application/json")], "{}", DiscoveryAbsentReasonNotFound),
      (200, [("Content-Type", "text/html")], "<html>", DiscoveryAbsentReasonNotFound),
      (200, [("Content-Type", "application/json"), ("ETag", "\"bad\"")], "{", DiscoveryAbsentReasonNotJson),
      (200, [("Content-Type", "application/json")], "[]", DiscoveryAbsentReasonInvalid),
      (200, [("Content-Type", "application/json")], Bytes.singleton 255, DiscoveryAbsentReasonUnreadable)
    ]
    $ \(code, headers, body, expected) -> do
      set (reply code headers body)
      require "HTTP discovery classified a refused document incorrectly" . reason expected =<< D.readDiscovery transport
      require "an unreadable document replaced the last good tag" . Bytes.isInfixOf "If-None-Match: \"one\"" =<< latest
  set (reply 200 [("Content-Type", "Application/JSON")] (Lazy.toStrict (encode document)))
  _ <- D.readDiscovery transport
  set (reply 304 [] "")
  _ <- D.readDiscovery transport
  require "a good document without a tag kept a stale one" . not . Bytes.isInfixOf "If-None-Match:" =<< latest
  set (reply 200 [("Content-Type", "application/json")] (Lazy.toStrict (encode document)))
  redirect <- Http.httpDiscovery client options Settings.protocolTransportTiming "http://launcher.test/redirect"
  require "discovery did not follow its redirect" . (== initial) =<< D.readDiscovery redirect
  blocked <- newTVarIO False
  never <- httpPeer $ \_ -> atomically (writeTVar blocked True) >> atomically retry
  deadline <- make never
  reading <- async (D.readDiscovery deadline)
  atomically (readTVar blocked >>= check)
  Time.settle
  let due = Timing.httpRequestTimeoutMs * 1000000
  Time.advance time (due - 1)
  require "discovery expired before the controlled deadline" . maybe True (const False) =<< poll reading
  Time.advance time 1
  require "HTTP discovery did not stop at its controlled deadline" . reason DiscoveryAbsentReasonUnreadable =<< wait reading
  interrupted <- async (D.readDiscovery deadline)
  Time.settle
  cancel interrupted
  cancellation <- httpPeer (const (throwIO UserInterrupt)) >>= make
  cancelled <- try (D.readDiscovery cancellation) :: IO (Either AsyncException DiscoveryRead)
  require "HTTP discovery swallowed asynchronous cancellation" (cancelled == Left UserInterrupt)
  putStrLn "PASS HTTP discovery, good-document ETags, redirects, controlled deadline and cancellation"
