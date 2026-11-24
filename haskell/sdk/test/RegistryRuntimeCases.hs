{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module RegistryRuntimeCases (registryRuntimeCases) where

import Control.Concurrent.Async (async, cancel, wait)
import Control.Concurrent.STM
import Control.Exception (bracket, finally)
import Control.Monad (forM_, unless, when)
import ControlledTime qualified as Time
import Data.Aeson (FromJSON, Result (..), Value (..), fromJSON, toJSON)
import Data.List (find)
import Data.Map.Strict qualified as Map
import Data.Set qualified as Set
import Data.Text (Text)
import Data.Text qualified as Text
import Data.UUID.Types qualified as UUID
import Network.HTTP.Client (defaultManagerSettings, noProxy)
import System.Timeout (timeout)
import Xynolog.Bus qualified as Bus
import Xynolog.Channels qualified as Channels
import Xynolog.Client qualified as Client
import Xynolog.Content qualified as Content
import Xynolog.Http qualified as Http
import Xynolog.Identity qualified as Identity
import Xynolog.Registry qualified as Browser
import Xynolog.Registry.Factory qualified as Factory
import Xynolog.Retry qualified as Retry
import Xynolog.Session qualified as Session
import Xynolog.SessionStorage qualified as Storage
import Xynolog.SignIn qualified as SignIn
import Xynolog.State.SessionSignals qualified as Signals
import Xynolog.StateValue qualified as State
import Xynolog.Timing.Settings qualified as Timing
import Xynolog.Transport qualified as Transport
import Xynolog.Types

require :: String -> Bool -> IO ()
require label good = unless good (ioError (userError label))

fixture :: (FromJSON result) => Map.Map Text Value -> Text -> IO result
fixture fixtures name = case Map.lookup name fixtures of
  Just value -> case fromJSON value of Success parsed -> pure parsed; Error diagnostic -> ioError (userError diagnostic)
  Nothing -> ioError (userError "Missing registry runtime fixture")

data Rig
  = Rig
      Factory.SessionFactory
      (TVar Int)
      (TVar (Maybe (Text, TMVar ())))
      (TVar (Maybe Text))
      (TVar (Maybe (Text, TMVar ())))
      (TVar [StoredSession])
      (TVar Int)
      Storage.SessionStorage
      (IO UUID.UUID)

rig :: Time.ControlledTime -> Map.Map Text Value -> IO Rig
rig time fixtures = do
  underlying <- Storage.newMemoryStorage
  active <- newTVarIO (0 :: Int)
  blocked <- newTVarIO Nothing
  different <- newTVarIO Nothing
  blockWrite <- newTVarIO Nothing
  revoked <- newTVarIO []
  detached <- newTVarIO (0 :: Int)
  ids <- newTVarIO (0 :: Integer)
  let fresh = atomically $ do modifyTVar' ids (+ 1); number <- readTVar ids; pure (UUID.fromWords 0 0 0 (fromInteger number))
      storage =
        underlying
          { Storage.set = \key value -> do
              hold <- readTVarIO blockWrite
              forM_ hold $ \(at, gate) -> when (key == Browser.activeKey && value == at) (atomically (readTMVar gate))
              Storage.set underlying key value,
            Storage.subscribe = \_ -> pure (Just (atomically (modifyTVar' detached (+ 1))))
          }
      clock = Retry.RetryOptions (Time.now time) (Time.waitUntil time) (pure 0)
      options = Bus.BusOptions (Time.now time) (Time.waitUntil time) (UUID.toText <$> fresh)
      contents =
        Content.ContentTransport
          (\_ _ _ _ -> ioError (userError "Unexpected upload"))
          (\_ _ -> ioError (userError "Unexpected binary read"))
          (\_ _ _ -> ioError (userError "Unexpected streamed read"))
          (\_ _ -> fixture fixtures "GetResourceResponse")
          (\_ _ -> fixture fixtures "GetAnnotationsResponse")
          (\_ _ -> fixture fixtures "AnchoredTextAnswer")
          (pure ())
      open inputs = do
        let kb = Factory.sessionFactoryOptionsKb inputs
        hold <- readTVarIO blocked
        forM_ hold $ \(at, gate) -> when (knowledgeBaseId kb == at) (atomically (readTMVar gate))
        count <- atomically $ do before <- readTVar active; writeTVar active (before + 1); pure before
        require "registry opened a new client before closing the previous one" (count == 0)
        inputCell <- newEmptyTMVarIO
        let send frame = do
              input <- atomically (readTMVar inputCell)
              case find (\(Channels.SomeOperation operation) -> let (request, _, _) = Channels.operationChannels operation in Channels.channelName request == busFrameChannel frame) Channels.allOperations of
                Nothing -> pure ()
                Just (Channels.SomeOperation operation) -> do
                  let (_, answer, _) = Channels.operationChannels operation
                  payload <-
                    if busFrameChannel frame == "browse:kb-requested"
                      then do
                        description <- fixture fixtures "KbDescription"
                        conflict <- readTVarIO different
                        domain <- case conflict of
                          Just value -> pure value
                          Nothing -> maybe (ioError (userError "Test KB declares no did:web identity")) pure (Text.stripPrefix "did:web:" (knowledgeBaseDid kb))
                        pure (toJSON (BrowseKbResult description {kbDescriptionDomain = domain, kbDescriptionName = knowledgeBaseLabel kb} mempty))
                      else maybe (ioError (userError "No scripted registry reply")) pure (Map.lookup (Channels.channelSchema answer) fixtures)
                  case payload of
                    Object fields -> Transport.receive input (BusFrame (Channels.channelName answer) (busFrameCorrelationId frame) (BusFramePayload fields) Nothing)
                    _ -> ioError (userError "Scripted registry reply is no object")
              pure (Just 1)
        (carrier, input) <- Transport.newTransport (Transport.TransportOptions "local://registry-runtime" (Set.fromList Channels.channelNames) send (pure ()))
        atomically (putTMVar inputCell input)
        Transport.setState input Transport.Connecting
        Transport.setState input Transport.Open
        client <- Client.newClient carrier contents Nothing options Timing.protocolSettings Nothing
        kept <- SignIn.newMemorySignIn
        let target = KbTarget (knowledgeBaseEndpoint kb) (knowledgeBaseId kb) (knowledgeBaseLabel kb) mempty
            settings =
              Session.SessionOptions
                (knowledgeBaseId kb)
                target
                kept
                Nothing
                Nothing
                Nothing
                (atomically . Signals.notifySessionEnded (Factory.sessionFactoryOptionsSignals inputs))
                (pure 1800000000)
        session <- Session.newSession client settings clock Timing.protocolSettings
        closed <- newTVarIO False
        let close = do
              first <- atomically $ do before <- readTVar closed; writeTVar closed True; pure (not before)
              when first ((Client.dispose client `finally` Session.dispose session) `finally` atomically (modifyTVar' active (subtract 1)))
        pure (Session.OpenedSession session close)
  pure (Rig (Factory.SessionFactory open (\grant -> atomically (modifyTVar' revoked (<> [grant])))) active blocked different blockWrite revoked detached storage fresh)

registryRuntimeCases :: Map.Map Text Value -> IO ()
registryRuntimeCases fixtures = do
  result <- timeout 20000000 (cases fixtures)
  require "Registry runtime failed its liveness guard" (result == Just ())
  putStrLn "PASS registry adoption, per-KB tabs, identity conflicts, stale activations, cancellation and joined teardown"

cases :: Map.Map Text Value -> IO ()
cases fixtures = do
  time <- Time.newTime
  Rig factory active blocked different blockWrite revoked detached storage fresh <- rig time fixtures
  pool <- Http.newHttpClient noProxy defaultManagerSettings
  let http =
        Http.HttpOptions
          "http://unused.test:1"
          pool
          (pure Nothing)
          (const (pure Nothing))
          (Retry.RetryOptions (Time.now time) (Time.waitUntil time) (pure 0))
          Timing.protocolSettings
          fresh
          Set.empty
          (pure Map.empty)
          (\_ _ -> pure ())
      config = Browser.XynologBrowserConfig storage factory http (pure 1800000000)
      local name = KbEndpointLocalEndpoint (LocalEndpoint name LocalEndpointKindLocal mempty)
      proposed name domain = NewKnowledgeBase (either error userIdValue (Identity.kbDid domain)) (local name) name Nothing mempty
  grant <- fixture fixtures "StoredSession"
  resource <- either (ioError . userError) pure (mkResourceId "res-1")
  bracket (Browser.newXynologBrowser config) Browser.dispose $ \browser -> do
    a <- Browser.addKb browser (proposed "A" "a.example.test") grant
    Time.settle
    require "registry did not own one active connection" . (== 1) =<< readTVarIO active
    let aId = knowledgeBaseId a
    Browser.addOpenResource browser resource "first name" (Just "text/plain") (Just "file://one.md")
    Browser.addOpenResource browser resource "renamed" Nothing Nothing
    Browser.setLastViewedResource browser resource
    opened <- atomically (State.current (Browser.openResources browser))
    require
      "opening an existing resource lost its media type or URI"
      ( case opened of
          [tab] -> openResourceName tab == "renamed" && openResourceMediaType tab == Just "text/plain" && openResourceStorageUri tab == Just "file://one.md"
          _ -> False
      )
    b <- Browser.addKb browser (proposed "B" "b.example.test") grant
    Time.settle
    require "switching KBs exposed another KB's open resources" . null =<< atomically (State.current (Browser.openResources browser))
    require "switching KBs exposed another KB's last-viewed resource" . (== Nothing) =<< atomically (State.current (Browser.lastViewedResource browser))
    Browser.setActiveKb browser (Just aId)
    -- Before background revalidation, the current storage still projects the
    -- last-viewed id for A, while B kept its own empty projection.
    require "KB switch lost its per-KB viewed bookmark" . (== Just resource) =<< atomically (State.current (Browser.lastViewedResource browser))
    Time.settle
    let description = KbDescription "another.example.test" Nothing "Another" mempty
        newGrant = grant {storedSessionAccess = "another-issued-access", storedSessionRefresh = "another-refresh"}
        signed = SignedIn description (knowledgeBaseEndpoint a) Nothing Nothing Nothing newGrant
    outcome <- Browser.signedIn browser signed
    Time.settle
    require "sign-in adopted an entry which the answering DID did not prove" (knowledgeBaseId (signInOutcomeKb outcome) /= aId)
    require "sign-in lost the user's belief in the previous entry" (fmap expectedDid (signInOutcomeExpected outcome) == Just (knowledgeBaseDid a))
    require "a different KB answering erased the original entry's credential" . (== Just grant) =<< Browser.storedSession storage aId
    require "the answering KB did not keep its own credential" . (== Just newGrant) =<< Browser.storedSession storage (knowledgeBaseId (signInOutcomeKb outcome))
    -- Read-only identity checks report a conflict without changing tabs; an
    -- activation's validation owns the act that voids stale content claims.
    Browser.setActiveKb browser (Just aId)
    Time.settle
    Browser.addOpenResource browser resource "kept until activation proves otherwise" Nothing Nothing
    atomically (writeTVar different (Just "other.example.test"))
    verdict <- Browser.readActiveKb browser
    require "a fresh description did not report the conflicting DID" (case verdict of KbReadVerdictConflict _ -> True; _ -> False)
    require "a read-only identity check voided open resources" . not . null =<< atomically (State.current (Browser.openResources browser))
    Browser.setActiveKb browser (Just (knowledgeBaseId b))
    Browser.setActiveKb browser (Just aId)
    Time.settle
    require "activation kept tabs of a different KB" . null =<< atomically (State.current (Browser.openResources browser))
    signals <- atomically (State.current (Browser.activeSignals browser)) >>= maybe (ioError (userError "No active session notices")) pure
    conflict <- atomically (State.current (Signals.kbIdentityConflict signals))
    require "activation did not surface the expected and observed identities" (conflict == Just (Signals.KbIdentityConflict (knowledgeBaseDid a) "did:web:other.example.test"))
    atomically (writeTVar different Nothing)
    gate <- newEmptyTMVarIO
    atomically (writeTVar blocked (Just (knowledgeBaseId b, gate)))
    openingB <- async (Browser.setActiveKb browser (Just (knowledgeBaseId b)))
    Time.settle
    openingA <- async (Browser.setActiveKb browser (Just aId))
    Time.settle
    require "a newer activation did not become the selected KB immediately" . (== Just aId) =<< atomically (State.current (Browser.activeKbId browser))
    atomically (putTMVar gate ())
    wait openingB
    wait openingA
    Time.settle
    require "superseded activation left more than one live client" . (== 1) =<< readTVarIO active
    atomically (writeTVar blocked Nothing)
    writeGate <- newEmptyTMVarIO
    atomically (writeTVar blockWrite (Just (knowledgeBaseId b, writeGate)))
    abandoned <- async (Browser.setActiveKb browser (Just (knowledgeBaseId b)))
    Time.settle
    cancel abandoned
    atomically (writeTVar blockWrite Nothing)
    Browser.setActiveKb browser (Just aId)
    Time.settle
    require "an abandoned selection lost the previous connection's teardown ownership" . (== 1) =<< readTVarIO active
    Browser.signOut browser aId
    Time.settle
    require "sign-out kept the active connection" . (== 0) =<< readTVarIO active
    require "sign-out kept its refresh grant" . (== Nothing) =<< Browser.storedSession storage aId
    require "sign-out did not notify its session factory of revocation" . (== [grant]) =<< readTVarIO revoked
    Browser.dispose browser
    Browser.dispose browser
    require "registry detached its external storage subscription more than once" . (== 1) =<< readTVarIO detached
  require "registry disposal left a client running" . (== 0) =<< readTVarIO active
