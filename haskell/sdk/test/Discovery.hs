{-# LANGUAGE OverloadedStrings #-}

module Discovery (discoveryCases) where

import Control.Concurrent.Async (async, wait)
import Control.Concurrent.STM
import Control.Exception (AsyncException (UserInterrupt), throwIO, try)
import Control.Monad (unless)
import Data.Aeson (Value (..), encode, toJSON)
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString qualified as Bytes
import Data.ByteString.Lazy qualified as Lazy
import Data.Text.Encoding (decodeUtf8, decodeUtf8')
import Streaming.Prelude qualified as Stream
import System.IO.Error (doesNotExistErrorType, mkIOError)
import System.Timeout (timeout)
import Xynolog.Discovery qualified as D
import Xynolog.Timing qualified as Timing
import Xynolog.Types
  ( DiscoveredKB (..),
    DiscoveryAbsent (..),
    DiscoveryAbsentKind (..),
    DiscoveryAbsentReason (..),
    DiscoveryDiff (..),
    DiscoveryDocument (..),
    DiscoveryManaged (..),
    DiscoveryManagedKind (..),
    DiscoveryRead (..),
    DiscoveryState (..),
    DiscoveryUnchanged (..),
    DiscoveryUnchangedKind (..),
  )

require :: String -> Bool -> IO ()
require label value = unless value (ioError (userError label))

discoveryCases :: DiscoveredKB -> DiscoveryDocument -> IO ()
discoveryCases sample sampleDocument = do
  result <- timeout 5000000 (cases sample sampleDocument)
  require "discovery liveness deadline expired" (result == Just ())
  putStrLn "PASS whole-document discovery, duplicate-aware diffs and controlled polling"

cases :: DiscoveredKB -> DiscoveryDocument -> IO ()
cases sample sampleDocument = do
  let kb = sample {discoveredKBHost = "localhost", discoveredKBPort = 8800, discoveredKBDid = "did:web:example.org"}
      other = kb {discoveredKBPort = 8801}
      changed = kb {discoveredKBSiteName = Just "New name"}
      document entries = sampleDocument {discoveryDocumentKbs = entries}
      render value = decodeUtf8 (Lazy.toStrict (encode value))
      parsed entries = D.parseDiscoveryDocument (render (document entries))
      managed kbs = DiscoveryStateDiscoveryManaged (DiscoveryManaged DiscoveryManagedKindManaged kbs)
      absent code diagnostic = DiscoveryStateDiscoveryAbsent (DiscoveryAbsent DiscoveryAbsentKindAbsent code diagnostic)
      managedRead kbs = DiscoveryReadDiscoveryManaged (DiscoveryManaged DiscoveryManagedKindManaged kbs)
      unchanged = DiscoveryReadDiscoveryUnchanged (DiscoveryUnchanged DiscoveryUnchangedKindUnchanged)
      reason expected value = case value of DiscoveryStateDiscoveryAbsent found -> discoveryAbsentReason found == expected; DiscoveryStateDiscoveryManaged _ -> False
      readReason expected value = case value of DiscoveryReadDiscoveryAbsent found -> discoveryAbsentReason found == expected; _ -> False
  require "empty managed document was treated as absent" (parsed [] == managed [])
  require "valid discovery entries were not retained" (parsed [kb, other] == managed [kb, other])
  require "malformed JSON was not classified" (reason DiscoveryAbsentReasonNotJson (D.parseDiscoveryDocument "{"))
  require "non-object document was not refused" (reason DiscoveryAbsentReasonInvalid (D.parseDiscoveryDocument "[]"))
  require
    "one invalid entry did not refuse the entire document"
    (reason DiscoveryAbsentReasonInvalid (parsed [kb, other {discoveredKBPort = 65536}]))
  let replace key value = case toJSON (document [kb]) of Object fields -> Object (KM.insert key value fields); _ -> error "generated document is not an object"
  require "unsupported version was read in part" (reason DiscoveryAbsentReasonUnsupportedVersion (D.parseDiscoveryDocument (render (replace "version" (Number 2)))))
  require "fractional version was not invalid" (reason DiscoveryAbsentReasonInvalid (D.parseDiscoveryDocument (render (replace "version" (Number 1.5)))))
  let initial = D.discoveryDiff Nothing (managed [kb])
  require "initial discovery did not report every entry" (fmap discoveryDiffAdded initial == Just [kb])
  require "a shared DID merged two addresses" (fmap discoveryDiffAdded (D.discoveryDiff (Just (managed [kb])) (managed [kb, other])) == Just [other])
  require "document reorder emitted a change" (D.discoveryDiff (Just (managed [kb, other])) (managed [other, kb]) == Nothing)
  require "metadata update was not reported" (fmap discoveryDiffUpdated (D.discoveryDiff (Just (managed [kb])) (managed [changed])) == Just [changed])
  let duplicate = D.discoveryDiff (Just (managed [kb])) (managed [kb, kb])
  require "an identical duplicate claim was hidden" (fmap discoveryDiffDuplicated duplicate == Just ["localhost:8800"])
  require
    "an unchanged ambiguous address emitted repeated updates"
    (D.discoveryDiff (Just (managed [kb, changed])) (managed [changed, kb]) == Nothing)
  let gone = absent DiscoveryAbsentReasonNotFound Nothing
  require
    "an absent launcher did not remove its managed entries"
    (fmap discoveryDiffRemoved (D.discoveryDiff (Just (managed [kb, other])) gone) == Just [kb, other])
  require
    "a diagnostic-only change emitted a state change"
    (D.discoveryDiff (Just gone) (absent DiscoveryAbsentReasonNotFound (Just "new diagnostic")) == Nothing)
  missing <- D.readDiscovery (D.textDiscovery (ioError (mkIOError doesNotExistErrorType "missing" Nothing Nothing)))
  require "missing file was not classified" (readReason DiscoveryAbsentReasonNotFound missing)
  unreadable <- D.readDiscovery (D.textDiscovery (ioError (userError "unreadable")))
  require "read failure was not classified" (readReason DiscoveryAbsentReasonUnreadable unreadable)
  badUtf8 <- D.readDiscovery (D.textDiscovery (either throwIO pure (decodeUtf8' (Bytes.singleton 255))))
  require "malformed UTF-8 was not classified" (readReason DiscoveryAbsentReasonUnreadable badUtf8)
  cancelled <- try (D.readDiscovery (D.textDiscovery (throwIO UserInterrupt))) :: IO (Either AsyncException DiscoveryRead)
  require "discovery swallowed cancellation" (cancelled == Left UserInterrupt)
  clock <- newTVarIO 0
  waits <- newTQueueIO
  observations <- newTVarIO [managedRead [kb], unchanged, managedRead [changed]]
  readCount <- newTVarIO (0 :: Int)
  let transport = D.DiscoveryTransport $ atomically $ do
        remaining <- readTVar observations
        case remaining of
          [] -> throwSTM (userError "discovery polled after its reader stopped")
          value : rest -> modifyTVar' readCount (+ 1) >> writeTVar observations rest >> pure value
      options =
        D.DiscoveryOptions
          { D.discoveryNow = readTVarIO clock,
            D.discoveryWaitUntil = \deadline -> do
              atomically (writeTQueue waits deadline)
              atomically (readTVar clock >>= check . (>= deadline)),
            D.discoveryIntervalMs = Timing.discoveryIntervalMs
          }
      duration = Timing.discoveryIntervalMs * 1000000
  worker <- async (Stream.toList_ (Stream.take 2 (D.subscribeDiscovery options transport)))
  first <- atomically (readTQueue waits)
  require "discovery ignored its caller-controlled interval" (first == duration)
  atomically (writeTVar clock (first - 1))
  before <- readTVarIO readCount
  require "discovery polled before the interval" (before == 1)
  atomically (writeTVar clock first)
  second <- atomically (readTQueue waits)
  afterUnchanged <- readTVarIO readCount
  require "unchanged response lost the polling cadence" (second == 2 * duration && afterUnchanged == 2)
  atomically (writeTVar clock second)
  notices <- wait worker
  require "discovery lost its initial or changed notice" (map discoveryDiffState notices == [managed [kb], managed [changed]])
  remainingWait <- atomically (tryReadTQueue waits)
  require "discovery retained polling work after consumption ended" (remainingWait == Nothing)
