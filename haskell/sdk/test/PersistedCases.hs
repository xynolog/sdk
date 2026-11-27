{-# LANGUAGE OverloadedStrings #-}

-- | protocol/specs/src/session/persisted-cases.json: what a client keeps of one person in a storage, and when it is
-- read, written and deleted.
module PersistedCases (persistedCases) where

import Control.Concurrent.Async (poll, wait, withAsync)
import Control.Concurrent.STM
import Control.Exception (bracket, finally)
import Control.Monad (forM, forM_, join, unless, void, when)
import ControlledTime qualified as Time
import Data.Aeson (FromJSON, Result (..), Value (..), eitherDecodeStrict', fromJSON, object, parseJSON, toJSON, (.=))
import Data.Aeson.Decoding.ByteString qualified as Tokens
import Data.Aeson.Decoding.Tokens (TkArray (..), TkRecord (..), Tokens (..))
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString qualified as Bytes
import Data.List (nub)
import Data.Map.Strict qualified as Map
import Data.Maybe (isJust)
import Data.Scientific (Scientific)
import Data.Set qualified as Set
import Data.Text (Text)
import Data.Text qualified as Text
import Data.UUID.Types qualified as UUID
import GatewayStage (Stage (..), newStage, registered, resumedFrom, resumedWith, send, signInOf, stageHttp)
import IssuerCases (route)
import Network.HTTP.Client (defaultManagerSettings, noProxy)
import SessionCases (jwt)
import Streaming.Prelude qualified as Stream
import System.FilePath ((</>))
import System.Timeout (timeout)
import Xynolog.Auth qualified as Auth
import Xynolog.Browse qualified as Browse
import Xynolog.Bus qualified as Bus
import Xynolog.Cache qualified as Cache
import Xynolog.Channels (Channel (MarkArchived), channelName)
import Xynolog.Client qualified as Client
import Xynolog.Content qualified as Content
import Xynolog.Http qualified as Http
import Xynolog.Identity qualified as Identity
import Xynolog.Internal.Browse qualified as BrowseState
import Xynolog.Internal.Generated.CachePersistence (KeptQuery (..), keptQueryName)
import Xynolog.Internal.Generated.Stored qualified as StoredKeys
import Xynolog.Internal.Kept qualified as Kept
import Xynolog.Issuer qualified as Issuer
import Xynolog.Registry qualified as Browser
import Xynolog.Registry.Factory qualified as Factory
import Xynolog.Retry (RetryOptions (..))
import Xynolog.Session qualified as Session
import Xynolog.SessionStorage qualified as Storage
import Xynolog.SignIn qualified as SignIn
import Xynolog.StateValue qualified as State
import Xynolog.StoragePersister (StoragePersister (..), newStoragePersister)
import Xynolog.Testing.Sessions qualified as Sessions
import Xynolog.Testing.Storage qualified as Shared
import Xynolog.Testing.Transport qualified as Faulty
import Xynolog.Timing qualified as Timing
import Xynolog.Timing.Settings qualified as Settings
import Xynolog.Types

failure :: Text -> String -> IO result
failure why message = ioError (userError ("persisted case " ++ show why ++ ": " ++ message))

field :: (FromJSON value) => Text -> Text -> Value -> IO value
field why name (Object fields) = case KM.lookup (Key.fromText name) fields of
  Just value | Success parsed <- fromJSON value -> pure parsed
  _ -> failure why ("states no " ++ Text.unpack name ++ " of its kind")
field why _ _ = failure why "is no object"

fixture :: (FromJSON result) => Map.Map Text Value -> Text -> IO result
fixture fixtures name = case Map.lookup name fixtures of
  Just value | Success parsed <- fromJSON value -> pure parsed
  _ -> ioError (userError ("no " ++ Text.unpack name ++ " fixture for the persisted cases"))

-- | A JSON value whose objects keep their members in the order its text states them.
data InOrder = Members [(Text, InOrder)] | Items [InOrder] | Scalar

inOrder :: Tokens k String -> Either String (InOrder, k)
inOrder (TkLit _ rest) = Right (Scalar, rest)
inOrder (TkText _ rest) = Right (Scalar, rest)
inOrder (TkNumber _ rest) = Right (Scalar, rest)
inOrder (TkArrayOpen items) = (\(values, rest) -> (Items values, rest)) <$> itemsInOrder items
inOrder (TkRecordOpen members) = (\(values, rest) -> (Members values, rest)) <$> membersInOrder members
inOrder (TkErr problem) = Left problem

itemsInOrder :: TkArray k String -> Either String ([InOrder], k)
itemsInOrder (TkItem item) = do
  (value, rest) <- inOrder item
  (values, end) <- itemsInOrder rest
  pure (value : values, end)
itemsInOrder (TkArrayEnd rest) = Right ([], rest)
itemsInOrder (TkArrayErr problem) = Left problem

membersInOrder :: TkRecord k String -> Either String ([(Text, InOrder)], k)
membersInOrder (TkPair key item) = do
  (value, rest) <- inOrder item
  (values, end) <- membersInOrder rest
  pure ((Key.toText key, value) : values, end)
membersInOrder (TkRecordEnd rest) = Right ([], rest)
membersInOrder (TkRecordErr problem) = Left problem

memberOf :: Text -> InOrder -> IO InOrder
memberOf name (Members members) = maybe (failure "the table" ("states no " ++ Text.unpack name)) pure (lookup name members)
memberOf name _ = failure "the table" ("holds " ++ Text.unpack name ++ " in what is no object")

-- | The table's `keys`: each row's persisted queries are the runner's, in refresh.json's order, and each key, the
-- stream's and every persisted query's, is the one the runner makes; and each person's key is the one their did makes.
keysPart :: Bytes.ByteString -> Value -> IO Int
keysPart text table = do
  ordered <- either (failure "the table" . ("is not JSON: " ++)) (pure . fst) (inOrder (Tokens.bsToTokens text))
  orderedRows <-
    memberOf "keys" ordered >>= \rows -> case rows of
      Items values -> pure values
      _ -> failure "the table" "states keys that are no list"
  rows <- field "the table" "keys" table :: IO [Value]
  unless (length rows == length orderedRows && not (null rows)) (failure "the table" "states keys this runner did not read")
  forM_ (zip rows orderedRows) $ \(row, orderedRow) -> do
    why <- field "a keys row" "why" row
    kbId <- field why "kbId" row
    did <- field why "did" row
    person <- field why "personKey" row
    lastEventIdKey <- field why "lastEventIdKey" row
    cacheKeys <- field why "cacheKeys" row :: IO (Map.Map Text Text)
    names <-
      memberOf "cacheKeys" orderedRow >>= \members -> case members of
        Members values -> pure (map fst values)
        _ -> failure why "states cache keys that are no object"
    unless (Kept.personKey did == person) (failure why ("makes the person's key " ++ show (Kept.personKey did)))
    unless (Kept.lastEventIdKey kbId person == lastEventIdKey) (failure why ("makes the places' key " ++ show (Kept.lastEventIdKey kbId person)))
    let queries = [minBound .. maxBound] :: [KeptQuery]
    unless (map keptQueryName queries == names) (failure why ("persists " ++ show (map keptQueryName queries) ++ ", not " ++ show names))
    forM_ queries $ \query ->
      unless
        (Map.lookup (keptQueryName query) cacheKeys == Just (Kept.cacheKey kbId person query))
        (failure why ("makes the " ++ Text.unpack (keptQueryName query) ++ " key " ++ show (Kept.cacheKey kbId person query)))
  people <- field "the table" "people" table :: IO (Map.Map Text (Map.Map Text Text))
  forM_ (Map.toList people) $ \(name, person) -> case (Map.lookup "did" person, Map.lookup "personKey" person) of
    (Just did, Just key) -> unless (Kept.personKey did == key) (failure name ("is keyed " ++ show (Kept.personKey did)))
    _ -> failure name "is no did and key"
  pure (length rows)

-- | The key of a person in the table's people.
personOf :: Value -> Text -> IO Text
personOf table name = do
  people <- field "the table" "people" table :: IO (Map.Map Text (Map.Map Text Text))
  maybe (failure "the table" ("names no person " ++ Text.unpack name)) pure (Map.lookup name people >>= Map.lookup "personKey")

-- | The table's `keys` row of a knowledge base and a person.
keyRowOf :: Value -> Text -> Text -> IO Value
keyRowOf table kbId person = do
  rows <- field "the table" "keys" table :: IO [Value]
  found <- forM rows $ \row -> do
    rowKb <- field "a keys row" "kbId" row
    rowPerson <- field "a keys row" "personKey" row
    pure [row | (rowKb, rowPerson) == (kbId :: Text, person)]
  case concat found of
    [row] -> pure row
    _ -> failure "the table" ("states the keys of " ++ Text.unpack person ++ " on " ++ Text.unpack kbId ++ " not once")

-- | Every key the table's `keys` say is kept on a knowledge base for a person: the stream's places, and each
-- persisted query's.
keysOf :: Value -> Text -> Text -> IO [Text]
keysOf table kbId person = do
  row <- keyRowOf table kbId person
  places <- field "a keys row" "lastEventIdKey" row
  caches <- field "a keys row" "cacheKeys" row :: IO (Map.Map Text Text)
  pure (places : Map.elems caches)

-- | The key the table's `keys` say a persisted query is kept under on a knowledge base for a person.
cacheKeyOf :: Value -> Text -> Text -> Text -> IO Text
cacheKeyOf table kbId person query = do
  caches <- keyRowOf table kbId person >>= field "a keys row" "cacheKeys" :: IO (Map.Map Text Text)
  maybe (failure "the table" ("keeps no " ++ Text.unpack query ++ " key")) pure (Map.lookup query caches)

-- | The table's `forgetStorage`, held once kb-a's client has closed to what the row `removes`: every key of the
-- person on kb-a gone, or none, and every other key holding what it held.
leftAsTheRowSays :: Text -> Value -> Text -> Storage.SessionStorage -> Text -> IO ()
leftAsTheRowSays why table removes storage jo = do
  seeded <- field "the table" "forgetStorage" table :: IO (Map.Map Text Text)
  removed <- case removes of
    "person" -> Set.fromList <$> keysOf table "kb-a" jo
    "nothing" -> pure Set.empty
    _ -> failure why ("removes " ++ show removes ++ ", which the table does not name")
  forM_ (Set.toList removed) $ \key ->
    Storage.get storage key >>= \held ->
      unless (held == Nothing) (failure why (Text.unpack key ++ " holds " ++ show held))
  forM_ (Map.toList seeded) $ \(key, value) ->
    unless (Set.member key removed) $
      Storage.get storage key >>= \held ->
        unless (held == Just value) (failure why (Text.unpack key ++ " holds " ++ show held ++ ", not what it held"))

-- | A stored sign-in of kb-a or kb-b, as the table's rows state it.
grantOf :: StoredSession -> Integer -> Maybe Text -> StoredSession
grantOf base serial person =
  base
    { storedSessionAccess = AccessToken (jwt 3600 serial),
      storedSessionRefresh = "refresh-" <> Text.pack (show serial),
      storedSessionPersonKey = person
    }

knowledgeBase :: Text -> KnowledgeBase
knowledgeBase key = KnowledgeBase {knowledgeBaseDid = (either error userIdValue (Identity.kbDid (key <> ".example.test"))), knowledgeBaseEndpoint = (KbEndpointLocalEndpoint (LocalEndpoint {localEndpointKbId = key, localEndpointKind = LocalEndpointKindLocal})), knowledgeBaseId = key, knowledgeBaseLabel = key, knowledgeBaseLastRead = Nothing}

-- | A row of `forget` the registry performs: signing out of kb-a, removing it, or signing in to it again with a new
-- sign-in, with kb-a and kb-b registered and kb-b active unless kb-a is open. The sessions are scripted, and one of
-- kb-a whose stored sign-in names jo when it is made writes under jo's resource key as it closes, as a client kept for
-- jo closing with a save pending could.
forgottenByTheRegistry :: Map.Map Text Value -> Value -> Text -> Value -> IO ()
forgottenByTheRegistry fixtures table jo row = do
  why <- field "a forget row" "why" row
  by <- field why "by" row :: IO Text
  signedIn <- field why "signedIn" row :: IO Text
  open <- field why "open" row :: IO Bool
  removes <- field why "removes" row :: IO Text
  seeded <- field "the table" "forgetStorage" table :: IO (Map.Map Text Text)
  time <- Time.newTime
  ids <- newTVarIO (0 :: Integer)
  let fresh = atomically (modifyTVar' ids (+ 1) >> readTVar ids)
      clock = RetryOptions (Time.now time) (Time.waitUntil time) (pure 0)
      busOptions = Bus.BusOptions (Time.now time) (Time.waitUntil time) (Text.pack . show <$> fresh)
      unexpected :: IO result
      unexpected = failure why "read content"
      contents _ =
        pure
          ( Content.ContentTransport
              (\_ _ _ _ -> unexpected)
              (\_ _ -> unexpected)
              (\_ _ _ -> unexpected)
              (\_ _ -> unexpected)
              (\_ _ -> unexpected)
              (\_ _ -> unexpected)
              (pure ()),
            Nothing
          )
  scripted <-
    Sessions.newScriptedSessions
      clock
      busOptions
      Settings.protocolClientTiming
      Settings.protocolTransportTiming
      (pure 1800000000)
      (\_ name payload -> Faulty.refuseUnscriptedOperation name payload)
      contents
  fixture fixtures "UserResponse" >>= Sessions.saysWho scripted . Just
  base <- fixture fixtures "StoredSession"
  store <- Storage.newMemoryStorage
  mapM_ (uncurry (Storage.set store)) (Map.toList seeded)
  Browser.saveKnowledgeBases store [knowledgeBase "kb-a", knowledgeBase "kb-b"]
  Storage.set store Browser.activeKey (if open then "kb-a" else "kb-b")
  case signedIn of
    "named" -> Browser.storeSession store "kb-a" (grantOf base 1 (Just jo))
    "unnamed" -> Browser.storeSession store "kb-a" (grantOf base 1 Nothing)
    "none" -> pure ()
    _ -> failure why ("is signed in " ++ show signedIn ++ ", which the table does not name")
  Browser.storeSession store "kb-b" (grantOf base 2 Nothing)
  joResource <- cacheKeyOf table "kb-a" jo "resource"
  let Factory.SessionFactory opening revoking = Sessions.factory scripted
      writesAsItCloses inputs = do
        Session.OpenedSession session close <- opening inputs
        kept <- if knowledgeBaseId (Factory.sessionFactoryOptionsKb inputs) == "kb-a" then Browser.storedSession store "kb-a" else pure Nothing
        pure
          ( Session.OpenedSession
              session
              ( if (kept >>= storedSessionPersonKey) == Just jo
                  then close >> Storage.set store joResource "{\"version\":1,\"entries\":[]}"
                  else close
              )
          )
      renewed = grantOf base 3 Nothing
  pool <- Http.newHttpClient noProxy defaultManagerSettings
  let http =
        Http.HttpOptions
          "http://unused.test:1"
          pool
          (pure Nothing)
          (const (pure Nothing))
          clock
          Settings.protocolTransportTiming
          (UUID.fromWords 0 0 0 . fromInteger <$> fresh)
          Set.empty
          (pure Map.empty)
          (\_ _ -> pure ())
      config = Browser.XynologBrowserConfig store (Factory.SessionFactory writesAsItCloses revoking) http Settings.protocolClientTiming (pure 1800000000)
  bracket (Browser.newXynologBrowser config) Browser.dispose $ \browser -> do
    Time.settle
    active <- atomically (State.current (Browser.activeKbId browser))
    live <- atomically (State.current (Browser.activeSession browser))
    unless
      (active == Just (if open then "kb-a" else "kb-b") && maybe False (const True) live)
      (failure why ("is active on " ++ show active ++ " with no session made"))
    case by of
      "signOut" -> Browser.signOut browser "kb-a"
      "removal" -> Browser.removeKb browser "kb-a"
      "signIn" -> Browser.signIn browser "kb-a" renewed
      _ -> failure why ("is forgotten by " ++ show by ++ ", which the registry does not do")
    Time.settle
    leftAsTheRowSays why table removes store jo
    when (by == "signIn") $
      Browser.storedSession store "kb-a" >>= \stored ->
        unless (stored == Just renewed) (failure why ("leaves kb-a signed in as " ++ show stored ++ ", not the new sign-in"))

forgetPart :: Map.Map Text Value -> Value -> Text -> IO Int
forgetPart fixtures table jo = do
  rows <- field "the table" "forget" table :: IO [Value]
  forM_ rows $ \row -> do
    by <- field "a forget row" "by" row :: IO Text
    if by `elem` ["signOut", "removal", "signIn"] then forgottenByTheRegistry fixtures table jo row else forgottenByTheSession table jo row
  pure (length rows)

-- | Waits for probe, the controlled clock moved on by a reconnect's debounce at a time, a hundred times at most.
eventually :: Time.ControlledTime -> Text -> String -> IO Bool -> IO ()
eventually time why what probe = do
  seen <- Time.within time (Timing.reconnectDebounceMs * 1000000) probe
  unless seen (failure why ("never saw " ++ what))

agreeOn :: (Eq value, Show value) => Text -> String -> value -> value -> IO ()
agreeOn why what found tabled = unless (found == tabled) (failure why (what ++ ": " ++ show found ++ "; the table's is " ++ show tabled))

-- | A member a row may leave out.
stated :: (FromJSON value) => Text -> Text -> Value -> IO (Maybe value)
stated why name (Object fields) = case KM.lookup (Key.fromText name) fields of
  Nothing -> pure Nothing
  Just value | Success parsed <- fromJSON value -> pure (Just parsed)
  Just _ -> failure why ("states a " ++ Text.unpack name ++ " of no kind the table names")
stated why _ _ = failure why "is no object"

-- | The did of a person in the table's people.
didOf :: Value -> Text -> IO Text
didOf table name = do
  people <- field "the table" "people" table :: IO (Map.Map Text (Map.Map Text Text))
  maybe (failure "the table" ("names no person " ++ Text.unpack name)) pure (Map.lookup name people >>= Map.lookup "did")

resourceNamed :: Text -> Text -> IO ResourceId
resourceNamed why = either (failure why) pure . mkResourceId

wallNow :: IO Scientific
wallNow = pure 1800000000

-- | A registry over storage whose sessions are the HTTP factory's, over the stage.
overTheStage :: Storage.SessionStorage -> Http.HttpOptions -> Browser.XynologBrowserConfig
overTheStage store http = Browser.XynologBrowserConfig store (Factory.newHttpSessionFactory http Settings.protocolClientTiming wallNow) http Settings.protocolClientTiming wallNow

-- | Storage holding kb-a, active, and its stored sign-in, naming the person given or nobody.
withKbA :: Storage.SessionStorage -> Text -> Maybe Text -> IO ()
withKbA store access person = do
  Browser.saveKnowledgeBases store [registered "kb-a"]
  Storage.set store Browser.activeKey "kb-a"
  Browser.storeSession store "kb-a" (signInOf Issuer.browserClientId access "r1" person)

-- | The registry's live session, once it has one.
liveOver :: Time.ControlledTime -> Text -> Browser.XynologBrowser -> IO Session.Session
liveOver time why browser = do
  eventually time why "a session come up" (isJust <$> atomically (State.current (Browser.activeSession browser)))
  atomically (State.current (Browser.activeSession browser)) >>= maybe (failure why "has no session") pure

noStrays :: Text -> Stage -> IO ()
noStrays why stage =
  readTVarIO (stageStrays stage) >>= \strays ->
    unless (null strays) (failure why ("asked the stage for what it has no answer for: " ++ show (map route strays)))

-- | res-1 as the gateway gives it to the session's client, with the clock standing still: no save the client comes
-- to owe falls due.
freshResource :: Time.ControlledTime -> Text -> Session.Session -> IO ResourceDescriptor
freshResource time why session = do
  identity <- resourceNamed why "res-1"
  withAsync (Cache.fresh (Browse.resource (Client.browse (Session.client session)) identity)) $ \reading -> do
    fetched <- Time.within time 0 (isJust <$> poll reading)
    unless fetched (failure why "never saw res-1 fetched with the clock standing still")
    wait reading

-- | The session's client holds what it has not written under the key, and owes the save.
unwritten :: Text -> Session.Session -> Storage.SessionStorage -> Text -> IO ()
unwritten why session store key = do
  written <- Storage.get store key
  owed <- atomically (BrowseState.persistencePending (Client.browse (Session.client session)))
  unless (written == Nothing && owed) (failure why "wrote what its client holds, or owes no save, before its sign-in changes")

-- | Whether a resource key holds res-1 as the client held it, read as a persister of the client's reads it.
holdsAsHeld :: Text -> Storage.SessionStorage -> Text -> ResourceDescriptor -> IO Bool
holdsAsHeld why store key held = do
  identity <- resourceNamed why "res-1"
  persister <-
    newStoragePersister
      (StoragePersister store key (pure 0) (pure ()))
      (\stored _ -> parseJSON stored) ::
      IO (Cache.CachePersister ResourceId ResourceDescriptor)
  kept <- lookup identity <$> Cache.load persister
  pure (fmap toJSON kept == Just (toJSON (held :: ResourceDescriptor)))

-- | The sign-in a crossTab or inProcess row changes the session's to: Nothing for the sign-in forgotten; otherwise the
-- person the new sign-in names, nobody for Nothing.
changedTo :: Text -> Value -> IO (Maybe (Maybe Text))
changedTo why row = do
  stored <- field why "stored" row :: IO (Maybe (Map.Map Text (Maybe Text)))
  traverse (\change -> maybe (failure why "states a sign-in with no personKey") pure (Map.lookup "personKey" change)) stored

-- | A row of `forget` a session performs: kb-a's session, the registry's own over the stage, renewing its token and
-- the issuer refusing, or finding its renewed token refused too. Its start forgets its sign-in.
forgottenByTheSession :: Value -> Text -> Value -> IO ()
forgottenByTheSession table jo row = do
  why <- field "a forget row" "why" row
  by <- field why "by" row :: IO Text
  stored <- field why "stored" row :: IO Text
  signedIn <- field why "signedIn" row :: IO Text
  open <- field why "open" row :: IO Bool
  removes <- field why "removes" row :: IO Text
  unless (by `elem` ["expiry", "refusal"]) (failure why ("is forgotten by " ++ show by ++ ", which a session does not do"))
  unless open (failure why ("is not open, and a session that is not open ends by no " ++ show by))
  seeded <- field "the table" "forgetStorage" table :: IO (Map.Map Text Text)
  whoAmI <- field "the table" "whoAmI" table :: IO Value
  access <- case stored of
    "expired" -> pure (jwt (-60) 1)
    "unexpired" -> pure (jwt 3600 1)
    _ -> failure why ("stores a token " ++ show stored ++ ", which the table does not name")
  person <- case signedIn of
    "named" -> pure (Just jo)
    "unnamed" -> pure Nothing
    _ -> failure why ("is signed in " ++ show signedIn ++ ", which the table does not name")
  let renewed = jwt 7200 2
  stage <- newStage
  atomically $ do
    writeTVar (stageWho stage) (Just whoAmI)
    when (stored == "unexpired") (modifyTVar' (stageRefusesWho stage) (Set.insert access))
    when (by == "refusal") $ do
      writeTVar (stageGrants stage) [(renewed, "r2")]
      modifyTVar' (stageRefusesWho stage) (Set.insert renewed)
  time <- Time.newTime
  store <- Storage.newMemoryStorage
  mapM_ (uncurry (Storage.set store)) (Map.toList seeded)
  withKbA store access person
  http <- stageHttp stage time
  bracket (Browser.newXynologBrowser (overTheStage store http)) Browser.dispose $ \_ ->
    eventually time why "kb-a's sign-in forgotten" ((== Nothing) <$> Browser.storedSession store "kb-a")
  leftAsTheRowSays why table removes store jo
  noStrays why stage

-- | A storage that records each key read and written under it.
watched :: Storage.SessionStorage -> IO (Storage.SessionStorage, TVar [Text], TVar [Text])
watched underlying = do
  readKeys <- newTVarIO []
  writtenKeys <- newTVarIO []
  let saw keys key = atomically (modifyTVar' keys (<> [key]))
  pure
    ( Storage.SessionStorage
        (\key -> saw readKeys key >> Storage.get underlying key)
        (\key value -> saw writtenKeys key >> Storage.set underlying key value)
        (\key -> saw writtenKeys key >> Storage.delete underlying key)
        (\key change -> saw writtenKeys key >> Storage.update underlying key change)
        (Storage.subscribe underlying),
      readKeys,
      writtenKeys
    )

-- | The keys seen that a person's things are kept under, each once.
keptKeys :: TVar [Text] -> IO [Text]
keptKeys seen =
  nub . filter (\key -> any (`Text.isPrefixOf` key) [StoredKeys.cacheKeyPrefix, StoredKeys.lastEventIdKeyPrefix])
    <$> readTVarIO seen

-- | The table's `startup`: kb-a's session made by a registry over the stage, its storage holding `startupStorage`,
-- the gateway's answer of who the token is held until it has been asked. A session is handed to the registry once
-- the gateway has answered, so what the client gives before then is read from the storage: `kept` is a client that
-- read the person's resource key before the gateway answered, `fresh` one that read no key a person's things are
-- kept under.
startupPart :: Value -> Text -> IO Int
startupPart table jo = do
  rows <- field "the table" "startup" table :: IO [Value]
  seeded <- field "the table" "startupStorage" table :: IO (Map.Map Text Text)
  whoAmI <- field "the table" "whoAmI" table :: IO Value
  resource <- cacheKeyOf table "kb-a" jo "resource"
  forM_ rows $ \row -> do
    why <- field "a startup row" "why" row
    signedIn <- field why "signedIn" row :: IO Text
    gateway <- field why "gateway" row :: IO Text
    first <- field why "first" row :: IO Text
    andThen <- field why "then" row :: IO Text
    recorded <- field why "recorded" row :: IO (Maybe Text)
    place <- field why "place" row :: IO (Maybe Text)
    untouched <- stated why "untouched" row :: IO (Maybe Bool)
    person <- case signedIn of
      "named" -> pure (Just jo)
      "unnamed" -> pure Nothing
      _ -> failure why ("is signed in " ++ show signedIn ++ ", which the table does not name")
    says <- case gateway of
      "names" -> pure (Just whoAmI)
      "unreachable" -> pure Nothing
      _ -> failure why ("has a gateway that " ++ show gateway ++ ", which the table does not name")
    stage <- newStage
    atomically (writeTVar (stageWhoHeld stage) True >> writeTVar (stageWho stage) says)
    time <- Time.newTime
    memory <- Storage.newMemoryStorage
    mapM_ (uncurry (Storage.set memory)) (Map.toList seeded)
    withKbA memory (jwt 3600 1) person
    (store, readKeys, writtenKeys) <- watched memory
    http <- stageHttp stage time
    bracket (Browser.newXynologBrowser (overTheStage store http)) Browser.dispose $ \browser -> do
      eventually time why "the gateway asked who the token is" (not . null <$> readTVarIO (stageAskedWho stage))
      readFirst <- keptKeys readKeys
      atomically (writeTVar (stageWhoHeld stage) False)
      session <- liveOver time why browser
      firstGiven <-
        if null readFirst
          then pure "fresh"
          else
            if resource `elem` readFirst
              then pure "kept"
              else failure why ("read " ++ show readFirst ++ " before the gateway answered")
      agreeOn why "first" firstGiven first
      Browser.storedSession store "kb-a" >>= \signIn -> agreeOn why "recorded" (signIn >>= storedSessionPersonKey) recorded
      identity <- resourceNamed why "res-1"
      given <- newEmptyTMVarIO
      let told = Stream.mapM_ (mapM_ (atomically . void . tryPutTMVar given . resourceDescriptorName) . Cache.readyValue)
      withAsync (Cache.watch (Browse.resource (Client.browse (Session.client session)) identity) told) $ \_ -> do
        eventually time why "res-1 given" (not <$> atomically (isEmptyTMVar given))
        atomically (readTMVar given) >>= \thenGiven -> agreeOn why "then" thenGiven andThen
        eventually time why "a stream name res-1's scope" (isJust <$> atomically (resumedFrom stage "res-1"))
        atomically (resumedFrom stage "res-1") >>= \from -> agreeOn why "place" (join from) place
    forM_ untouched $ \expected -> do
      held <- and <$> forM (Map.toList seeded) (\(key, value) -> (== Just value) <$> Storage.get memory key)
      written <- keptKeys writtenKeys
      added <- or <$> forM [key | key <- written, Map.notMember key seeded] (fmap isJust . Storage.get memory)
      agreeOn why "untouched" (held && not added) expected
    noStrays why stage
  pure (length rows)

-- | The table's `crossTab`: kb-a's client, kept for jo and holding a value of res-1 it has not written, the save
-- not yet due; another context of the storage writes kb-a's stored sign-in as the row says, and the registry
-- closes.
crossTabPart :: Value -> Text -> IO Int
crossTabPart table jo = do
  rows <- field "the table" "crossTab" table :: IO [Value]
  whoAmI <- field "the table" "whoAmI" table :: IO Value
  resource <- cacheKeyOf table "kb-a" jo "resource"
  forM_ rows $ \row -> do
    why <- field "a crossTab row" "why" row
    change <- changedTo why row
    saved <- field why "saved" row :: IO Bool
    stage <- newStage
    atomically (writeTVar (stageWho stage) (Just whoAmI))
    time <- Time.newTime
    shared <- Shared.newSharedStorage
    other <- Shared.storage <$> Shared.context shared
    let store = Shared.storage shared
    withKbA store (jwt 3600 1) (Just jo)
    http <- stageHttp stage time
    held <- bracket (Browser.newXynologBrowser (overTheStage store http)) Browser.dispose $ \browser -> do
      session <- liveOver time why browser
      value <- freshResource time why session
      unwritten why session store resource
      case change of
        Nothing -> Storage.delete other (Browser.sessionKey "kb-a")
        Just named | named == Just jo -> do
          let renewing = Browser.keptIn other "kb-a"
          before <- SignIn.held renewing >>= maybe (failure why "holds no sign-in to renew") pure
          SignIn.renewed renewing before (IssuedTokens (jwt 7200 2) "r-other") >>= \renewal ->
            unless (isJust renewal) (failure why "renewed nothing in the other context")
        Just named -> Browser.storeSession other "kb-a" (signInOf Issuer.browserClientId (jwt 7200 2) "r-other" named)
      pure value
    holdsAsHeld why store resource held >>= \found -> agreeOn why "saved" found saved
    noStrays why stage
  pure (length rows)

-- | The table's `inProcess`: a session made over a memory sign-in naming jo, keeping its caches in a storage of their
-- own, its client holding a value of res-1 it has not written, the save not yet due; the sign-in is changed
-- through the memory sign-in as the row says, and the session closes.
inProcessPart :: Value -> Text -> IO Int
inProcessPart table jo = do
  rows <- field "the table" "inProcess" table :: IO [Value]
  whoAmI <- field "the table" "whoAmI" table :: IO Value
  resource <- cacheKeyOf table "kb-a" jo "resource"
  forM_ rows $ \row -> do
    why <- field "an inProcess row" "why" row
    change <- changedTo why row
    saved <- field why "saved" row :: IO Bool
    stage <- newStage
    atomically (writeTVar (stageWho stage) (Just whoAmI))
    time <- Time.newTime
    memory <- SignIn.newMemorySignIn
    SignIn.keep memory (signInOf Issuer.scriptClientId (jwt 3600 1) "r1" (Just jo))
    caches <- Storage.newMemoryStorage
    http <- stageHttp stage time
    let kb = registered "kb-a"
        whoIs client access = case Client.auth client of
          Nothing -> failure why "has a client with no gateway identity operation"
          Just auth -> Just <$> Auth.me auth (Just access)
        options =
          Session.SessionOptions
            "kb-a"
            (KbTarget {kbTargetEndpoint = (knowledgeBaseEndpoint kb), kbTargetId = "kb-a", kbTargetLabel = "KB A"})
            memory
            Nothing
            Nothing
            (Just whoIs)
            (const (pure ()))
            wallNow
    opened <- withAsync (Session.fromKeptSession http Settings.protocolClientTiming (Just caches) options) $ \opening -> do
      eventually time why "the session open" (isJust <$> poll opening)
      wait opening
    held <-
      ( do
          let session = Session.openedSession opened
          value <- freshResource time why session
          unwritten why session caches resource
          case change of
            Nothing -> SignIn.forget memory
            Just named | named == Just jo -> do
              before <- SignIn.held memory >>= maybe (failure why "holds no sign-in to renew") pure
              SignIn.renewed memory before (IssuedTokens (jwt 7200 2) "r-renewed") >>= \renewal ->
                unless (isJust renewal) (failure why "renewed nothing through what holds the sign-in")
            Just named -> SignIn.keep memory (signInOf Issuer.scriptClientId (jwt 7200 2) "r-other" named)
          pure value
      )
        `finally` Session.closeOpenedSession opened
    holdsAsHeld why caches resource held >>= \found -> agreeOn why "saved" found saved
    noStrays why stage
  pure (length rows)

-- | An event on res-1's scope, by jo.
archived :: Text -> Int -> Value
archived did serial =
  object
    [ "channel" .= channelName MarkArchived,
      "scope" .= String "res-1",
      "payload"
        .= object
          [ "id" .= String "0e2f8c0a-4a34-4a8e-9b47-0d6d5a3f8a11",
            "type" .= channelName MarkArchived,
            "timestamp" .= String "2026-10-27T12:00:00.000Z",
            "userId" .= did,
            "resourceId" .= String "res-1",
            "version" .= (1 :: Int),
            "metadata" .= object ["sequenceNumber" .= serial],
            "payload" .= object []
          ]
    ]

-- | The table's `resumeFrom`: kb-a's client, kept for jo, holds res-1's scope while the stream delivers each of a
-- row's events on it, then holds res-2's too: the stream that names res-2 says where res-1's scope resumes.
resumeFromPart :: Value -> Text -> IO Int
resumeFromPart table jo = do
  rows <- field "the table" "resumeFrom" table :: IO [Value]
  whoAmI <- field "the table" "whoAmI" table :: IO Value
  joDid <- didOf table "jo"
  forM_ rows $ \row -> do
    why <- field "a resumeFrom row" "why" row
    frames <- field why "frames" row :: IO [Text]
    resumes <- field why "resumes" row :: IO (Maybe Text)
    stage <- newStage
    atomically (writeTVar (stageWho stage) (Just whoAmI))
    time <- Time.newTime
    store <- Storage.newMemoryStorage
    withKbA store (jwt 3600 1) (Just jo)
    http <- stageHttp stage time
    bracket (Browser.newXynologBrowser (overTheStage store http)) Browser.dispose $ \browser -> do
      session <- liveOver time why browser
      let hold name = do
            identity <- resourceNamed why name
            Cache.watch (Browse.resource (Client.browse (Session.client session)) identity) Stream.effects
      withAsync (hold "res-1") $ \_ -> do
        eventually time why "a stream name res-1's scope" (isJust <$> atomically (resumedFrom stage "res-1"))
        forM_ (zip [1 ..] frames) $ \(serial, identity) -> atomically (send stage (Just identity) (archived joDid serial))
        Time.settle
        withAsync (hold "res-2") $ \_ -> do
          eventually time why "a stream name res-2's scope with res-1's" (isJust <$> atomically (resumedWith stage "res-1" "res-2"))
          atomically (resumedWith stage "res-1" "res-2") >>= \from -> agreeOn why "resumes" (join from) resumes
    noStrays why stage
  pure (length rows)

persistedCases :: FilePath -> Map.Map Text Value -> IO ()
persistedCases root fixtures = do
  text <- Bytes.readFile (root </> "protocol/specs/src/session/persisted-cases.json")
  table <- either (ioError . userError) pure (eitherDecodeStrict' text)
  jo <- personOf table "jo"
  outcome <-
    timeout 60000000 $
      sum
        <$> sequence
          [ keysPart text table,
            forgetPart fixtures table jo,
            startupPart table jo,
            crossTabPart table jo,
            inProcessPart table jo,
            resumeFromPart table jo
          ]
  ran <- maybe (ioError (userError "the persisted cases did not finish in a minute")) pure outcome
  putStrLn ("PASS " ++ show ran ++ " shared persisted cases")
