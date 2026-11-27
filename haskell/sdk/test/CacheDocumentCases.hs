{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}

-- | protocol/specs/src/session/cache-cases.json, run through each kept query's
-- own persister over an in-memory storage, under the keys session/stored.json
-- gives.
module CacheDocumentCases (cacheDocumentCases) where

import Control.Concurrent.STM (STM, atomically, check, newTVarIO, readTVar, retry, writeTVar)
import Control.Monad (forM, forM_, unless, when)
import Data.Aeson (FromJSON, Result (..), ToJSON, Value (..), eitherDecodeStrict', encode, fromJSON, parseJSON, toJSON)
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString qualified as Bytes
import Data.ByteString.Lazy qualified as Lazy
import Data.Foldable (toList)
import Data.Map.Strict qualified as Map
import Data.Proxy (Proxy (..))
import Data.Scientific (floatingOrInteger)
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.Encoding (decodeUtf8, encodeUtf8)
import System.FilePath ((</>))
import System.Timeout (timeout)
import Xynolog.Cache qualified as Cache
import Xynolog.Internal.CacheDocument (Whole)
import Xynolog.Internal.Coupled qualified as Coupled
import Xynolog.Internal.Generated.CachePersistence (KeptQuery (..), keptQueryName)
import Xynolog.Internal.Generated.CacheRefresh qualified as Fact
import Xynolog.Internal.Generated.TimingSettings (settingsOf)
import Xynolog.Internal.Kept qualified as Kept
import Xynolog.Internal.Persistence qualified as Persistence
import Xynolog.SessionStorage qualified as Storage
import Xynolog.Timing.Settings qualified as Settings
import Xynolog.Types (AnnotationId, ResourceId, resourceIdValue)

type Using result =
  forall key value.
  (ToJSON key, FromJSON key, ToJSON value, FromJSON value, Eq value) =>
  Proxy key -> Proxy value -> IO result

-- | What each kept query's cache is keyed by and holds.
kept :: KeptQuery -> Using result -> IO result
kept Resource use = use (Proxy :: Proxy ResourceId) (Proxy :: Proxy Fact.ResourceValue)
kept Annotations use = use (Proxy :: Proxy ResourceId) (Proxy :: Proxy Fact.AnnotationsValue)
kept Annotation use = use (Proxy :: Proxy AnnotationId) (Proxy :: Proxy Fact.AnnotationValue)
kept EntityTypes use = use (Proxy :: Proxy Whole) (Proxy :: Proxy Fact.EntityTypesValue)
kept TagSchemas use = use (Proxy :: Proxy Whole) (Proxy :: Proxy Fact.TagSchemasValue)

kb, person :: Text
kb = "kb-cases"
person = "person-cases"

failure :: Text -> String -> IO result
failure name reason = ioError (userError (Text.unpack name ++ ": " ++ reason))

member :: Text -> Text -> Value -> IO Value
member name key (Object fields) = maybe (failure name ("states no " ++ Text.unpack key)) pure (KM.lookup (Key.fromText key) fields)
member name _ _ = failure name "is no object"

textOf :: Text -> Value -> IO Text
textOf _ (String value) = pure value
textOf name _ = failure name "names no text"

listOf :: Text -> Value -> IO [Value]
listOf _ (Array values) = pure (toList values)
listOf name _ = failure name "states no list"

decoded :: (FromJSON value) => Text -> Value -> IO value
decoded name value = case fromJSON value of
  Success parsed -> pure parsed
  Error reason -> failure name ("holds a value that is not the query's: " ++ reason)

-- | The text a case keeps under its key: `stored` as JSON, or `storedText` as it is.
storedText :: Text -> Value -> IO Text
storedText name (Object fields) = case (KM.lookup "stored" fields, KM.lookup "storedText" fields) of
  (Just value, Nothing) -> pure (decodeUtf8 (Lazy.toStrict (encode value)))
  (Nothing, Just (String value)) -> pure value
  _ -> failure name "states not exactly one of stored and storedText"
storedText name _ = failure name "is no object"

-- | Key and value pairs compared as a map, the key by its JSON text.
asMap :: [(Value, Value)] -> Map.Map Text Value
asMap pairs = Map.fromList [(decodeUtf8 (Lazy.toStrict (encode key)), value) | (key, value) <- pairs]

-- | The table's entries, each its @key@ and its @value@.
entriesOf :: Text -> Value -> IO [(Value, Value)]
entriesOf name entries =
  listOf name entries
    >>= traverse
      ( \entry -> case entry of
          Object fields | KM.size fields == 2, Just key <- KM.lookup "key" fields, Just value <- KM.lookup "value" fields -> pure (key, value)
          _ -> failure name "states an entry that is not a key and a value"
      )

-- | The case's query, and the key its document is kept under, by the case's own name for it.
queryOf :: Text -> Value -> IO (KeptQuery, Text)
queryOf name row = do
  queryName <- member name "query" row >>= textOf name
  case [query | query <- [minBound .. maxBound], keptQueryName query == queryName] of
    [query] -> pure (query, Kept.cacheKey kb person query)
    _ -> failure name ("names " ++ Text.unpack queryName ++ ", no kept query")

-- | The persister the client gives a kept query; its host's clock is not in whole milliseconds.
persisterOf ::
  (ToJSON key, FromJSON key, ToJSON value, FromJSON value) =>
  Storage.SessionStorage -> KeptQuery -> IO (Cache.CachePersister key value)
persisterOf storage query = do
  coupled <- Coupled.newCoupled storage (Kept.lastEventIdKey kb person)
  Persistence.persister
    (Persistence.CachePersistence storage kb person (pure 1800000000000.6))
    coupled
    (settingsOf Settings.protocolClientTiming Settings.protocolTransportTiming)
    query
    (\key _ -> parseJSON key)

loadCase :: Value -> IO ()
loadCase row = do
  name <- member "a load case" "name" row >>= textOf "a load case"
  (query, key) <- queryOf name row
  storage <- Storage.newMemoryStorage
  storedText name row >>= Storage.set storage key
  loaded <-
    kept
      query
      ( \(_ :: Proxy key) (_ :: Proxy value) -> do
          persister <- persisterOf storage query :: IO (Cache.CachePersister key value)
          entries <- Cache.load persister
          pure [(toJSON identity, toJSON value) | (identity, value) <- entries]
      )
  expected <- member name "kept" row >>= entriesOf name
  unless (asMap loaded == asMap expected) (failure name ("kept " ++ show loaded))

-- | A cache of the case's query, saving to @storage@ and waiting out its debounce with @wait@, given the case's
-- @held@; @between@ is handed whether it owes a save, and then the cache is disposed.
holding :: Text -> Value -> KeptQuery -> Storage.SessionStorage -> (Integer -> IO ()) -> (STM Bool -> IO ()) -> IO ()
holding name row query storage wait between = do
  held <- member name "held" row >>= entriesOf name
  kept
    query
    ( \(_ :: Proxy key) (_ :: Proxy value) -> do
        persister <- persisterOf storage query :: IO (Cache.CachePersister key value)
        values <- forM held (\(identity, value) -> (,) <$> decoded name identity <*> decoded name value) :: IO [(key, value)]
        cache <-
          Cache.newCache
            (\_ -> failure name "asked the wire")
            (Cache.CacheOptions (pure 0) wait (Just persister) (const (pure (pure ()))))
        forM_ values (uncurry (Cache.set cache))
        between (Cache.persistencePending cache)
        Cache.dispose cache
    )

-- | Disposal's flush is the only save: the debounce never ends.
writeCase :: Value -> IO ()
writeCase row = do
  name <- member "a write case" "name" row >>= textOf "a write case"
  (query, key) <- queryOf name row
  storage <- Storage.newMemoryStorage
  holding name row query storage (const (atomically retry)) (const (pure ()))
  writtenAsStated name storage key row

-- | The debounce ends at once, so the save the cache owes is made, and the storage refuses it; the cache still owes
-- it, and disposal's flush, which the storage takes, writes the case's document.
refusedWriteCase :: Value -> IO ()
refusedWriteCase row = do
  name <- member "a refused write case" "name" row >>= textOf "a refused write case"
  (query, key) <- queryOf name row
  memory <- Storage.newMemoryStorage
  refused <- newTVarIO False
  let refuses written = when (written == key) $ do
        first <- atomically (readTVar refused >>= \done -> if done then pure False else True <$ writeTVar refused True)
        when first (ioError (userError "the storage refuses the first write of the query's document"))
      storage =
        Storage.SessionStorage
          (Storage.get memory)
          (\written value -> refuses written >> Storage.set memory written value)
          (Storage.delete memory)
          (\written change -> refuses written >> Storage.update memory written change)
          (Storage.subscribe memory)
  outcome <- timeout 10000000 $ holding name row query storage (const (pure ())) $ \owes -> do
    atomically (readTVar refused >>= check)
    pending <- atomically owes
    unless pending (failure name "owes no save after the storage refused it")
  maybe (failure name "the storage was not asked for the document in ten seconds") pure outcome
  writtenAsStated name storage key row

-- | The document kept under @key@ is the case's @written@: its version, and its entries as a map, each stamped with
-- a whole number of at least 0.
writtenAsStated :: Text -> Storage.SessionStorage -> Text -> Value -> IO ()
writtenAsStated name storage key row = do
  raw <- Storage.get storage key >>= maybe (failure name "wrote no document") pure
  document <- either (failure name) pure (eitherDecodeStrict' (encodeUtf8 raw) :: Either String Value)
  written <- member name "written" row
  version <- member name "version" document
  expectedVersion <- member name "version" written
  unless (version == expectedVersion) (failure name ("wrote version " ++ show version))
  entries <- member name "entries" document >>= listOf name
  writtenPairs <- forM entries $ \entry -> do
    parts <- listOf name entry
    case parts of
      [identity, value, Number stamp] | Right at <- (floatingOrInteger stamp :: Either Double Integer), at >= 0 -> pure (identity, value)
      _ -> failure name ("wrote an entry that is not a key, a value and a whole-number stamp of at least 0: " ++ show entry)
  expected <- member name "entries" written >>= entriesOf name
  unless (asMap writtenPairs == asMap expected) (failure name ("wrote " ++ show writtenPairs))

placesCase :: Value -> IO ()
placesCase row = do
  name <- member "a places case" "name" row >>= textOf "a places case"
  storage <- Storage.newMemoryStorage
  storedText name row >>= Storage.set storage (Kept.lastEventIdKey kb person)
  coupled <- Coupled.newCoupled storage (Kept.lastEventIdKey kb person)
  loaded <- Coupled.loadPositions coupled
  expected <-
    member name "kept" row >>= \value -> case value of
      Object fields -> forM (KM.toList fields) (\(scope, place) -> (,) (Key.toText scope) <$> textOf name place)
      _ -> failure name "keeps no object"
  let held = Map.fromList [(resourceIdValue scope, place) | (scope, place) <- Map.toList loaded]
  unless (held == Map.fromList expected) (failure name ("kept " ++ show held))

cacheDocumentCases :: FilePath -> IO ()
cacheDocumentCases root = do
  table <-
    Bytes.readFile (root </> "protocol/specs/src/session/cache-cases.json")
      >>= either (ioError . userError) pure . eitherDecodeStrict'
  loads <- member "the cache table" "cases" table >>= listOf "the cache table"
  writes <- member "the cache table" "writes" table >>= listOf "the cache table"
  refusals <- member "the cache table" "refusedWrites" table >>= listOf "the cache table"
  places <- member "the cache table" "places" table >>= listOf "the cache table"
  mapM_ loadCase loads
  mapM_ writeCase writes
  mapM_ refusedWriteCase refusals
  mapM_ placesCase places
  putStrLn
    ( "PASS "
        ++ show (length loads + length writes + length refusals + length places)
        ++ " shared cache document, write, refused write and places cases"
    )
