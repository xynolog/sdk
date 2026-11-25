{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import ActorCases (actorCases)
import AnnotationCases (annotationCases)
import BusCases (busCases)
import BusLogCases (busLogCases)
import CacheCases (cacheCases)
import CacheDocumentCases (cacheDocumentCases)
import ClientAssertionCases (clientAssertionCases)
import ClockCases (cacheClockCases, clientClockCases, clockCensus, discoveryClockCases, httpClockCases, jobPollClockCases)
import Control.Applicative ((<|>))
import Control.Monad (forM, forM_, unless)
import Data.Aeson (FromJSON, Value (..), eitherDecodeStrict', parseJSON, toJSON)
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.Aeson.Types (parseEither)
import Data.ByteString qualified as Bytes
import Data.Char (isDigit, isSpace)
import Data.Either (isLeft)
import Data.Foldable (toList)
import Data.IORef (modifyIORef', newIORef, readIORef)
import Data.List (isSuffixOf, sortOn)
import Data.Map.Strict qualified as Map
import Data.Set qualified as Set
import Data.Text (Text)
import Data.Text qualified as T
import Data.Vector qualified as V
import DelegationCases (delegationCases, followerClockCases)
import Discovery (discoveryCases)
import FlowCases (flowCases)
import FrameCases (frameCases)
import GHC.IO.Encoding (setFileSystemEncoding)
import GatewayCases (gatewayCases)
import HeldCases (heldCases, heldClockCases)
import HttpCases (httpCases)
import HttpDiscoveryCases (httpDiscoveryCases)
import IdentityCases (identityCases)
import IssuerCases (deviceClockCases, issuerCases, serviceTokenCases)
import LifetimeCases (lifetimeCases)
import OpenResourceCases (openResourceCases)
import PersistedCases (persistedCases)
import PersistenceCases (persistenceCases)
import RefreshCases (refreshCases)
import RegistryCases (registryCases)
import RegistryErrorsCases (registryErrorsCases)
import RegistryRuntimeCases (registryRuntimeCases)
import ResourceCases (resourceCases)
import Runtime (runtimeCases)
import SchemaCases qualified
import SessionCases (sessionCases, sessionClockCases)
import ShapeCases (shapeCases)
import SignInStoreCases (signInStoreCases, storeWriter)
import StateUnitCases (stateUnitCases)
import SurfaceCases (surfaceCases)
import System.Directory (doesDirectoryExist, listDirectory)
import System.Environment (getArgs)
import System.FilePath (takeBaseName, (</>))
import System.IO (BufferMode (LineBuffering), hSetBuffering, stdout, utf8)
import TestingCases (testingCases)
import TextCases (textCases)
import TokenStorageCases (tokenStorageCases)
import WorkerCases (workerCases)
import Xynolog.Channels qualified as Channels
import Xynolog.ErrorCodes qualified as Errors
import Xynolog.Internal.Generated.ChannelRoundTrip (channelMetadata, operationMetadata, roundTripChannel)
import Xynolog.Internal.Generated.DiscoveryReasonRoundTrip qualified as DiscoveryReasons
import Xynolog.Internal.Generated.ErrorRoundTrip (roundTripError)
import Xynolog.Internal.Generated.RoundTrip (enumerationCases, roundTrip)
import Xynolog.Internal.Generated.Schemas (schemas)
import Xynolog.Internal.Generated.ServiceEnvironmentValues (serviceEnvironmentValues)
import Xynolog.Internal.Generated.TimingValues (timingValues)
import Xynolog.Internal.Required qualified as Required
import Xynolog.Internal.Schema (checkSchema, validate, validateNamed)
import Xynolog.Retry qualified as Retry
import Xynolog.ServiceTables (serviceTables)
import Xynolog.Tables (tables)
import Xynolog.Timing.Settings qualified as TimingSettings
import Xynolog.Types qualified as Types

require :: String -> Bool -> IO ()
require label good = unless good (ioError (userError label))

readJSON :: FilePath -> IO Value
readJSON path = Bytes.readFile path >>= either (ioError . userError) pure . eitherDecodeStrict'

object :: Value -> KM.KeyMap Value
object (Object fields) = fields
object _ = KM.empty

array :: Value -> [Value]
array (Array values) = toList values
array _ = []

at :: Key.Key -> Value -> Value
at key value = maybe Null id (KM.lookup key (object value))

-- Whether a property's schema admits null: null its second type, or a member of its union.
admitsNull :: Value -> Bool
admitsNull field = case at "type" field of
  Array names -> String "null" `V.elem` names
  _ -> any (elem (Object (KM.fromList [("type", String "null")])) . array . flip at field) ["anyOf", "oneOf"]

-- A part of a pattern of Protocol's subset of ECMA-262: a character of a
-- class, or a group of alternatives, each with its fewest repetitions.
data Atom = Character (Char -> Bool) | Alternatives [[(Atom, Int)]]

-- The shortest text [pattern] matches: each part repeated as few times as it
-- may, a class's first letter, digit or punctuation it allows, and a group's
-- first alternative. An end the pattern does not anchor takes nothing more.
patternSample :: Text -> Text
patternSample pattern = T.pack (render (fst (alternatives (T.unpack (T.dropWhileEnd (== '$') (T.dropWhile (== '^') pattern))))))
  where
    render = \case
      first : _ -> concatMap (\(atom, fewest) -> concat (replicate fewest (one atom))) first
      [] -> ""
    one = \case
      Character allows -> take 1 (filter allows (['a' .. 'z'] ++ ['A' .. 'Z'] ++ ['0' .. '9'] ++ "-_.:/@~{} "))
      Alternatives choices -> render choices
    alternatives text = case series text of
      (first, '|' : more) -> let (others, rest) = alternatives more in (first : others, rest)
      (first, rest) -> ([first], rest)
    series text = case text of
      c : _ | c `elem` (")|" :: String) -> ([], text)
      [] -> ([], [])
      _ ->
        let (atom, afterAtom) = part text
            (fewest, afterCount) = count afterAtom
            (others, rest) = series afterCount
         in ((atom, fewest) : others, rest)
    part = \case
      '(' : text -> let (choices, rest) = alternatives text in (Alternatives choices, drop 1 rest)
      '[' : '^' : text -> let (allows, rest) = members text in (Character (not . allows), rest)
      '[' : text -> let (allows, rest) = members text in (Character allows, rest)
      '\\' : c : text -> (Character (escaped c), text)
      '.' : text -> (Character (/= '\n'), text)
      c : text -> (Character (== c), text)
      [] -> (Character (const False), [])
    members = \case
      ']' : text -> (const False, text)
      '\\' : c : text -> let (others, rest) = members text in (\x -> escaped c x || others x, rest)
      low : '-' : high : text | high /= ']' -> let (others, rest) = members text in (\x -> (x >= low && x <= high) || others x, rest)
      c : text -> let (others, rest) = members text in (\x -> x == c || others x, rest)
      [] -> (const False, [])
    escaped = \case
      'S' -> not . isSpace
      's' -> isSpace
      'd' -> isDigit
      c -> (== c)
    count = \case
      '*' : text -> (0, text)
      '+' : text -> (1, text)
      '?' : text -> (0, text)
      '{' : text -> let (digits, rest) = span isDigit text in (read digits, drop 1 (dropWhile (/= '}') rest))
      text -> (1, text)

-- [fields] without its alternatives, and with [alternative] beside it: each
-- member as both state it, and the members both require.
within :: KM.KeyMap Value -> Value -> KM.KeyMap Value
within fields alternative = KM.unionWithKey beside (KM.delete "oneOf" (KM.delete "anyOf" fields)) (object alternative)
  where
    beside "properties" (Object own) (Object stated) = Object (KM.unionWith (\mine theirs -> Object (KM.union (object theirs) (object mine))) own stated)
    beside "required" (Array own) (Array stated) = Array (own <> stated)
    beside _ _ stated = stated

-- Names an object's [propertyNames] allow, most likely first; any name when
-- it states none.
memberNames :: Value -> [Text]
memberNames schema = case at "propertyNames" schema of
  Null -> ["__haskell_probe"]
  names -> case at "enum" names of
    Array values -> [name | String name <- toList values]
    _ -> case at "pattern" names of
      String pattern -> [patternSample pattern]
      _ -> []

sample :: Int -> Value -> Either String Value
sample = variant 0

-- A value [schema] admits: its required members and the first valid
-- choice at each place, or, as variant [k] above 0, every optional member
-- it can sample too and the k-th valid choice at each place.
variant :: Int -> Int -> Value -> Either String Value
variant k depth schema
  | depth > 40 = Left "required schema recursion exceeds sample budget"
  | otherwise = do
      let fields = object schema
          nested = variant k (depth + 1)
          unstatedMember owner = case at "additionalProperties" owner of
            Bool False -> Left "required member is neither stated nor allowed"
            Null -> Right (Bool True)
            definition -> nested definition
          choose candidates = case filter (either (const False) (const True) . validate schemas schema) candidates of
            valid@(_ : _) -> Right (valid !! (k `mod` length valid))
            [] -> Left ("no valid generated sample for " ++ show schema)
      case KM.lookup "$ref" fields of
        Just (String reference) -> case Map.lookup (T.pack (takeBaseName (T.unpack reference))) schemas of
          Just target -> nested target
          Nothing -> Left "sample reference has no schema"
        _ -> case KM.lookup "enum" fields <|> fmap (Array . pure) (KM.lookup "const" fields) of
          Just (Array values) -> choose (toList values)
          _ -> case KM.lookup "oneOf" fields <|> KM.lookup "anyOf" fields of
            Just (Array alternatives)
              | KM.member "type" fields -> choose [value | Right value <- map (nested . Object . within fields) (toList alternatives)]
              | otherwise -> choose [value | Right value <- map nested (toList alternatives)]
            _ -> case KM.lookup "type" fields of
              Just (String "string") -> do
                let width = case KM.lookup "minLength" fields of Just (Number n) -> ceiling n; _ -> 0
                let patterned = case KM.lookup "pattern" fields of Just (String pattern) -> [patternSample pattern]; _ -> []
                choose [String text | text <- patterned ++ [T.replicate width "a", "a", "did:example:probe", "did:web:probe", "e-a", "e-a:b:c", "p-a-1", T.replicate 64 "a"]]
              Just (String "integer") -> choose [Number (case KM.lookup "minimum" fields of Just (Number n) -> fromInteger (ceiling n); _ -> 0)]
              Just (String "number") -> choose [Number (case KM.lookup "minimum" fields of Just (Number n) -> n; _ -> 0)]
              Just (String "boolean") -> Right (Bool False)
              Just (String "null") -> Right Null
              Just (Array names) | [declared, String "null"] <- toList names -> nested (Object (KM.insert "type" declared fields))
              Just (String "array") -> do
                let size = case KM.lookup "minItems" fields of Just (Number n) -> ceiling n; _ -> 0
                    member = at "items" schema
                items <- case (KM.lookup "uniqueItems" fields, at "enum" member) of
                  (Just (Bool True), Array values) -> Right (take size (toList values))
                  _ -> mapM (const (nested member)) [1 :: Int .. size]
                choose [Array (V.fromList items)]
              Just (String "object") -> do
                let properties = object (at "properties" schema)
                required <-
                  mapM
                    ( \key -> case key of
                        String name -> do
                          let member = Key.fromText name
                          (,) member <$> maybe (unstatedMember schema) nested (KM.lookup member properties)
                        _ -> Left "required name is not a string"
                    )
                    (array (at "required" schema))
                let fewest = case KM.lookup "minProperties" fields of Just (Number n) -> ceiling n; _ -> 0
                    optional = [(key, definition) | (key, definition) <- KM.toList properties, not (any ((== key) . fst) required)]
                added <-
                  if k > 0
                    then Right [(key, value) | (key, definition) <- optional, Right value <- [nested definition]]
                    else mapM (\(key, definition) -> (,) key <$> nested definition) (take (fewest - length required) optional)
                let stated = required ++ added
                    unstated = [Key.fromText name | name <- memberNames schema, not (any ((== Key.fromText name) . fst) stated)]
                extra <- mapM (\key -> (,) key <$> unstatedMember schema) (take (fewest - length stated) unstated)
                choose [Object (KM.fromList (stated ++ extra))]
              Nothing -> Right Null
              _ -> Left "sample shape unsupported"

-- Whether an object holds the members its schema does not name: when it says
-- what they are, or names none of its own.
holdsOthers :: Value -> Bool
holdsOthers schema = at "additionalProperties" schema /= Null || KM.null (object (at "properties" schema))

expectRoundTrip :: Text -> Value -> IO ()
expectRoundTrip name value = case roundTrip name value of
  Left reason -> ioError (userError (T.unpack name ++ ": " ++ reason))
  Right encoded -> require (T.unpack name ++ " lost JSON members: " ++ show value ++ " -> " ++ show encoded) (encoded == value)

schemaCases :: FilePath -> IO ()
schemaCases root = do
  files <- listDirectory (root </> "protocol/specs/src/components/schemas")
  forM_ [T.pack (takeBaseName file) | file <- files, ".json" `isSuffixOf` file] $ \name ->
    require ("missing generated schema: " ++ T.unpack name) (Map.member name schemas)
  forM_ (Map.toAscList schemas) $ \(name, definition) -> do
    either (ioError . userError . ((T.unpack name ++ ": ") ++)) pure (checkSchema schemas definition)
    value <- either (ioError . userError . ((T.unpack name ++ ": ") ++)) pure (sample 0 definition)
    expectRoundTrip name value
    let properties = object (at "properties" definition)
        required = array (at "required" definition)
    forM_ (KM.toList properties) $ \(key, field) -> do
      if not (admitsNull field)
        then pure ()
        else do
          expectRoundTrip name (Object (KM.insert key Null (object value)))
          if String (Key.toText key) `elem` required
            then pure ()
            else expectRoundTrip name (Object (KM.delete key (object value)))
    case value of
      Object fields | at "type" definition == String "object" && at "additionalProperties" definition /= Bool False && at "maxProperties" definition == Null -> do
        extra <- case at "additionalProperties" definition of
          typed@(Object _) -> either (ioError . userError) pure (sample 0 typed)
          _ -> pure (Number 18446744073709551617)
        case [Key.fromText probe | probe <- memberNames definition, not (KM.member (Key.fromText probe) fields)] of
          probe : _
            | holdsOthers definition -> expectRoundTrip name given
            | otherwise -> require (T.unpack name ++ " kept a member its schema does not name: " ++ show given) (roundTrip name given == Right value)
            where
              given = Object (KM.insert probe extra fields)
          [] -> pure ()
      _ -> pure ()
    forM_ [1 .. 3] $ \k -> case variant k 0 definition of
      Right fuller -> expectRoundTrip name fuller
      Left _ -> pure ()
    case at "enum" definition of
      Array values -> do
        mapM_ (expectRoundTrip name) values
        let unknown candidate = if String candidate `V.elem` values then unknown (candidate <> "_") else candidate
        require (T.unpack name ++ " accepted an unknown enum member") (isLeft (roundTrip name (String (unknown "__haskell_unknown"))))
      _ -> pure ()

-- Every value of every enumeration the models declare is written as
-- Protocol states it, read back as itself, and, of words, has its word.
enumerationValueCases :: IO ()
enumerationValueCases = forM_ enumerationCases $ \(name, wire, written, readBack, word) -> do
  let label = T.unpack name ++ " " ++ show wire
  require (label ++ " is written as " ++ show written) (written == wire)
  require (label ++ " is read back as " ++ show readBack) (readBack == Right wire)
  require (label ++ " has the word " ++ show word) (maybe True ((== wire) . String) word)

identifierCases :: FilePath -> IO ()
identifierCases root = do
  kinds <- readJSON (root </> "protocol/specs/src/identifiers/kinds.json")
  forM_ (array (at "kinds" kinds)) $ \kind -> case at "schema" kind of
    String name -> do
      forM_ (array (at "accepts" kind)) $ \entry -> expectRoundTrip name (at "id" entry)
      forM_ (array (at "refuses" kind)) $ \entry ->
        require (T.unpack name ++ " accepted " ++ show (at "id" entry)) (isLeft (roundTrip name (at "id" entry)))
    _ -> ioError (userError "identifier table has no schema name")

-- Each service table as the SDK carries it is the table as Protocol states it, but its prose.
tableCases :: FilePath -> IO ()
tableCases root = forM_ (serviceTables ++ tables) $ \(file, carried) -> do
  stated <- readJSON (root </> "protocol/specs/src" </> T.unpack file)
  require (T.unpack file ++ " is not carried as Protocol states it") (carried == stated)

filesUnder :: FilePath -> IO [FilePath]
filesUnder directory = do
  names <- listDirectory directory
  fmap concat $
    mapM
      ( \name -> do
          let path = directory </> name
          nested <- doesDirectoryExist path
          if nested then filesUnder path else pure [path | ".json" `isSuffixOf` name]
      )
      names

corpusCases :: FilePath -> IO ()
corpusCases root = do
  registry <- readJSON (root </> "protocol/specs/src/bus/registry.json")
  let channels = Map.fromList [(name, channel) | channel <- array (at "channels" registry), String name <- [at "channel" channel]]
  held <- newIORef (0 :: Int)
  refused <- newIORef (0 :: Int)
  let resolve names value = case value of
        Object fields -> case KM.lookup "$var" fields of
          Just (String key) -> KM.lookup (Key.fromText key) names
          _ -> case KM.lookup "$join" fields of
            Just (Array parts) -> String . T.concat <$> traverse (\part -> case resolve names part of Just (String text) -> Just text; _ -> Nothing) (toList parts)
            _ -> Object <$> traverse (resolve names) fields
        Array values -> Array <$> traverse (resolve names) values
        String "_" -> Nothing
        _ -> Just value
      walk names value = case value of
        Object fields -> do
          let bindings = KM.mapMaybe (resolve names) (object (at "let" value))
              current = bindings <> names
          case (KM.lookup "channel" fields, KM.lookup "payload" fields) of
            (Just (String channel), Just raw) -> case (Map.lookup channel channels, resolve current raw) of
              (Just channelSchema, Just resolved) -> do
                let shape = at "shape" channelSchema
                    payload = if shape == String "envelope" then at "response" resolved else resolved
                    named = at (if shape == String "storedEvent" then "payload" else "schema") channelSchema
                case named of
                  String name | payload /= Null -> case validateNamed schemas name payload of
                    Left _ -> do
                      require "decoder accepted a schema-invalid corpus payload" (isLeft (roundTrip name payload))
                      modifyIORef' refused (+ 1)
                    Right () -> expectRoundTrip name payload >> modifyIORef' held (+ 1)
                  _ -> pure ()
              _ -> pure ()
            _ -> pure ()
          foldWalk current (map snd (KM.toList fields))
        Array values -> foldWalk names (toList values)
        _ -> pure names
      foldWalk names [] = pure names
      foldWalk names (value : rest) = walk names value >>= \next -> foldWalk next rest
  forM_ ["sdk/wire", "sdk/live", "worker"] $ \part -> do
    files <- filesUnder (root </> "protocol/conformance" </> part)
    forM_ files $ \path -> do
      value <- readJSON path
      let initial =
            KM.fromList [(Key.fromText key, String key) | key <- ["r1", "r2", "r3", "a1", "a2"]]
              <> KM.fromList [(Key.fromText key, String ("did:web:example.org:users:" <> key)) | key <- ["client", "participant"]]
      _ <- walk initial value
      pure ()
  count <- readIORef held
  failures <- readIORef refused
  require "corpus runner executed no payloads" (count > 0)
  putStrLn ("PASS corpus payloads: " ++ show count ++ " round-trips; " ++ show failures ++ " schema-invalid refusals")

channelCases :: FilePath -> IO ()
channelCases root = do
  registry <- readJSON (root </> "protocol/specs/src/bus/registry.json")
  let channels = array (at "channels" registry)
  require "registry declares no channels" (not (null channels))
  forM_ channels $ \channel -> do
    name <- case at "channel" channel of String value -> pure value; _ -> ioError (userError "channel name missing")
    named <- case at "shape" channel of
      String "schema" -> case at "schema" channel of String value -> pure value; _ -> ioError (userError "channel schema missing")
      String "storedEvent" -> pure (if at "enriched" channel == Bool True then "EnrichedResourceEvent" else "StoredEventResponse")
      String "envelope" -> case at "schema" channel of String value -> pure (value <> "BusEnvelope"); _ -> ioError (userError "envelope schema missing")
      String "empty" -> pure "EmptyBusPayload"
      String "void" -> pure "EmptyBusPayload"
      _ -> ioError (userError "unrecognized channel shape")
    require "channel metadata disagrees with the registry" (channelMetadata name == Right (name, named, String name `elem` array (at "scoped" (at "audience" registry))))
    schema <- maybe (ioError (userError ("missing generated channel schema: " ++ T.unpack named))) pure (Map.lookup named schemas)
    payload <- either (ioError . userError) pure (sample 0 schema)
    stamped <- case payload of
      Object fields -> pure (Object (KM.insert "__testStamp" (String "gateway-owned") fields))
      _ -> ioError (userError "channel payload is not an object")
    require
      ("channel decoder lost a declared stamp or retained an unknown one on " ++ T.unpack name)
      (roundTripChannel name stamped == Right payload)
    require "common channel shape disagrees with the typed codec" (Required.faultChannel name stamped == Nothing)
    require "channel accepted a non-object payload" (isLeft (roundTripChannel name Null))
  require "channel inventory disagrees with the registry" (map String Channels.channelNames == map (at "channel") channels)
  let operations = array (at "operations" registry)
      actualOperations = [(String asked, String result, String failure) | (asked, result, failure) <- operationMetadata]
  require "operation routing disagrees with the registry" (actualOperations == [(at "request" row, at "result" row, at "failure" row) | row <- operations])
  require "persisted event vocabulary disagrees with the registry" (map String Channels.persistedEventTypes == [value | row <- channels, let value = at "event" row, value /= Null])
  putStrLn ("PASS typed payload decoding and stamp handling for all " ++ show (length channels) ++ " registry channels")

factCases :: FilePath -> IO ()
factCases root = do
  errors <- readJSON (root </> "protocol/specs/src/errors/codes.json")
  let families = KM.delete "$comment" (object errors)
  require "no error families" (not (KM.null families))
  forM_ (KM.toList families) $ \(family, group) -> do
    let codes = array (at "codes" group)
    require "empty error family" (not (null codes))
    forM_ codes $ \row -> do
      let code = at "code" row
      require "error code codec changed its wire spelling" (roundTripError (Key.toText family) code == Right code)
    require "unknown error code was accepted" (isLeft (roundTripError (Key.toText family) (String "__unknown_test_code")))
  let transport = at "transport" errors
      statuses = array (at "codes" transport)
      exact status = [at "code" row | row <- statuses, at "status" row == Number (fromIntegral status)]
      ranges status = sortOn (negate . fst) [(floor', at "code" row) | row <- statuses, Number floor' <- [at "statusFrom" row], fromIntegral status >= floor']
      expected status = case exact status of
        code : _ -> code
        [] -> case ranges status of (_, code) : _ -> code; [] -> at "unclassified" transport
  forM_ [0 .. 600] $ \status ->
    require "HTTP status classifier differs from spec" (String (Errors.transportCode (Errors.transportCodeFromStatus status)) == expected status)
  environment <- readJSON (root </> "protocol/specs/src/service-environment/variables.json")
  let expectedEnvironment = Map.fromList [(T.unpack name, T.unpack name) | row <- array (at "variables" environment), String name <- [at "name" row]]
  require "service environment variables differ from spec" (not (Map.null expectedEnvironment) && expectedEnvironment == serviceEnvironmentValues)
  timings <- readJSON (root </> "protocol/specs/src/client/timing.json")
  let expectedTiming = Map.fromList [(key, at "value" row) | row <- array (at "timing" timings), String key <- [at "name" row]]
  require "timing constants or retry budgets differ from spec" (not (Map.null expectedTiming) && expectedTiming == timingValues)
  require
    "configurable timings differ from the protocol constants"
    (toJSON TimingSettings.protocolSettings == Object (KM.fromList [(Key.fromText key, value) | (key, value) <- Map.toList expectedTiming]))
  forM_ (Map.toList expectedTiming) $ \(key, value) -> do
    let changed = case value of
          Number number -> Number (number + 1)
          Object fields -> Object (KM.mapWithKey (\member number -> case number of Number n | member == "attempts" -> Number (n + 1); other -> other) fields)
          other -> other
        overridden = TimingSettings.withOverrides (Object (KM.singleton (Key.fromText key) changed))
    require
      "a protocol timing cannot be overridden"
      (fmap toJSON overridden == Right (Object (KM.fromList [(Key.fromText name, if name == key then changed else original) | (name, original) <- Map.toList expectedTiming])))
  forM_
    [ Object (KM.singleton "unknown" (Number 1)),
      Object (KM.singleton "reconnectMs" (Number (-1))),
      Object (KM.singleton "emitRetry" (Object KM.empty)),
      Object (KM.singleton "reconnectMs" (Number 0.5))
    ]
    $ \invalid ->
      require "malformed timing override was accepted" (isLeft (TimingSettings.withOverrides invalid))
  putStrLn "PASS every error vocabulary, wire/HTTP classifiers, timing constant and retry budget"
  discovery <- readJSON (root </> "protocol/specs/src/client/discovery-absent.json")
  forM_ (array (at "reasons" discovery)) $ \row -> do
    let reason = at "reason" row
    require
      "discovery reason differs from its authority"
      (DiscoveryReasons.roundTripError "discoveryAbsent" reason == Right reason)
  require
    "unknown discovery reason was accepted"
    (isLeft (DiscoveryReasons.roundTripError "discoveryAbsent" (String "__unknown_test_reason")))

retryCases :: FilePath -> IO ()
retryCases root = do
  table <- readJSON (root </> "protocol/specs/src/retry/cases.json")
  let rules = [minBound .. maxBound] :: [Retry.RetryRule]
      rows = array (at "rules" table)
      decode :: (FromJSON value) => Value -> IO value
      decode value = either (ioError . userError) pure (parseEither parseJSON value)
  names <- traverse (decode . at "rule") rows
  require
    "retry rule vocabulary differs from its authority"
    (Set.fromList names == Set.fromList (map Retry.ruleName rules))
  forM_ rows $ \row -> do
    require "retry table gained an unhandled fact" (all (`elem` ["why", "rule", "status", "method", "keyed", "retries"]) (KM.keys (object row)))
    name <- decode (at "rule" row)
    rule <- case filter ((== name) . Retry.ruleName) rules of
      [one] -> pure one
      _ -> ioError (userError "unknown retry rule")
    status <- decode (at "status" row)
    method <- decode (at "method" row)
    keyed <- decode (at "keyed" row)
    expected <- decode (at "retries" row)
    require ("retry decision differs from spec: " ++ show (at "why" row)) (Retry.retryable rule status method (keyed == Just True) == expected)
  forM_ (array (at "retryAfter" table)) $ \row -> do
    header <- decode (at "header" row)
    expected <- decode (at "ms" row)
    require "Retry-After differs from spec" (Retry.retryAfterMs header == expected)
  putStrLn "PASS all retry rules and Retry-After cases"

-- | Holds the JSON text to the shape written as the table writes one.
faultsAs :: Bytes.ByteString -> Bytes.ByteString -> Maybe Required.Fault -> IO ()
faultsAs written text expected = do
  shape <- either (ioError . userError . (("no required shape " ++ show written ++ ": ") ++)) pure (eitherDecodeStrict' written)
  value <- either (ioError . userError) pure (eitherDecodeStrict' text)
  let actual = Required.walk shape value ""
  require (show text ++ " as " ++ show written ++ " has the fault " ++ show actual ++ ", not " ++ show expected) (actual == expected)

-- | A pattern's group is one of its alternatives, repeated as often as it
-- says, and a text is of the pattern when some reading of it takes all of it.
-- An object carries no set of notAll whole, a member that holds null being
-- carried; carries at least minMembers members; and names each of its members
-- as names says. A reader refuses a part it does not know.
requiredWalkerCases :: IO ()
requiredWalkerCases = do
  let malformed way = Just (Required.Fault way Types.FrameRefusalReasonMalformed)
      lacks way = Just (Required.Fault way Types.FrameRefusalReasonLacks)
      letter = "{\"of\":[[97,122]],\"min\":1,\"max\":1}"
      anything = "{\"of\":[[0,1114111]],\"min\":0}"
      methodThen end = "{\"kinds\":[\"string\"],\"pattern\":[{\"either\":[[{\"of\":[[71,71]],\"min\":1,\"max\":1},{\"of\":[[69,69]],\"min\":1,\"max\":1},{\"of\":[[84,84]],\"min\":1,\"max\":1}],[{\"of\":[[80,80]],\"min\":1,\"max\":1},{\"of\":[[79,79]],\"min\":1,\"max\":1},{\"of\":[[83,83]],\"min\":1,\"max\":1},{\"of\":[[84,84]],\"min\":1,\"max\":1}]],\"min\":1,\"max\":1},{\"of\":[[32,32]],\"min\":1,\"max\":1},{\"of\":[[47,47]],\"min\":1,\"max\":1}" <> end <> "]}"
      method = methodThen ("," <> anything)
      anchoredMethod = methodThen ""
  faultsAs method "\"GET /\"" Nothing
  faultsAs method "\"POST /kb/x\"" Nothing
  faultsAs method "\"PUT /\"" (malformed "")
  faultsAs method "\"GET\"" (malformed "")
  faultsAs anchoredMethod "\"GET /\"" Nothing
  faultsAs anchoredMethod "\"GET /kb/x\"" (malformed "")

  let kebab = "{\"kinds\":[\"string\"],\"pattern\":[{\"of\":[[97,122]],\"min\":1},{\"either\":[[{\"of\":[[45,45]],\"min\":1,\"max\":1},{\"of\":[[97,122]],\"min\":1}]],\"min\":0}]}"
  faultsAs kebab "\"a\"" Nothing
  faultsAs kebab "\"one-two-three\"" Nothing
  faultsAs kebab "\"one--two\"" (malformed "")
  faultsAs kebab "\"one-\"" (malformed "")

  let twoOrThreeLetters = "{\"kinds\":[\"string\"],\"pattern\":[{\"either\":[[" <> letter <> "]],\"min\":2,\"max\":3}]}"
  faultsAs twoOrThreeLetters "\"ab\"" Nothing
  faultsAs twoOrThreeLetters "\"abc\"" Nothing
  faultsAs twoOrThreeLetters "\"a\"" (malformed "")
  faultsAs twoOrThreeLetters "\"abcd\"" (malformed "")

  let lettersThenLetter = "{\"kinds\":[\"string\"],\"pattern\":[{\"either\":[[" <> letter <> "]],\"min\":0}," <> letter <> "]}"
  faultsAs lettersThenLetter "\"abc\"" Nothing
  faultsAs lettersThenLetter "\"\"" (malformed "")

  let emptyRepeated = "{\"kinds\":[\"string\"],\"pattern\":[{\"either\":[[{\"of\":[[97,97]],\"min\":0}]],\"min\":0},{\"of\":[[98,98]],\"min\":1,\"max\":1}]}"
  faultsAs emptyRepeated "\"aab\"" Nothing
  faultsAs emptyRepeated "\"aac\"" (malformed "")

  require "a term that is both a step and a group was read" (isLeft (eitherDecodeStrict' "{\"pattern\":[{\"of\":[[97,97]],\"either\":[],\"min\":1}]}" :: Either String Required.Shape))
  require "a term with a part no reader knows was read" (isLeft (eitherDecodeStrict' "{\"pattern\":[{\"of\":[[97,97]],\"min\":1,\"times\":2}]}" :: Either String Required.Shape))
  require "a shape with a part no reader knows was read" (isLeft (eitherDecodeStrict' "{\"kinds\":[\"object\"],\"notAny\":[[\"a\"]]}" :: Either String Required.Shape))

  let portOrExternal = "{\"kinds\":[\"object\"],\"notAll\":[[\"port\",\"external\"]]}"
  faultsAs portOrExternal "{\"port\":1}" Nothing
  faultsAs portOrExternal "{\"external\":\"x\"}" Nothing
  faultsAs portOrExternal "{\"port\":1,\"external\":\"x\"}" (malformed "")
  faultsAs portOrExternal "{\"port\":1,\"external\":null}" (malformed "")

  let oneOrMore = "{\"kinds\":[\"object\"],\"minMembers\":1}"
  faultsAs oneOrMore "{\"a\":1}" Nothing
  faultsAs oneOrMore "{}" (malformed "")

  let lower = "{\"kinds\":[\"object\"],\"names\":{\"kinds\":[\"string\"],\"pattern\":[{\"of\":[[97,122]],\"min\":1}]}}"
  faultsAs lower "{\"ab\":1,\"cd\":2}" Nothing
  faultsAs lower "{\"ab\":1,\"Cd\":2,\"X\":3}" (malformed "Cd")
  faultsAs ("{\"kinds\":[\"object\"],\"members\":[[\"providers\"," <> lower <> "]]}") "{\"providers\":{\"Cd\":2}}" (malformed "providers.Cd")

  let ordered = "{\"kinds\":[\"object\"],\"required\":[\"a\"],\"names\":{\"kinds\":[\"string\"],\"pattern\":[{\"of\":[[97,122]],\"min\":1}]},\"notAll\":[[\"a\",\"b\"]]}"
  faultsAs ordered "{\"B\":1}" (lacks "a")
  faultsAs ordered "{\"a\":1,\"B\":1}" (malformed "B")
  faultsAs ordered "{\"a\":1,\"b\":1}" (malformed "")
  let boundedFirst = "{\"kinds\":[\"object\"],\"minMembers\":2,\"required\":[\"a\"]}"
  faultsAs boundedFirst "{}" (malformed "")
  faultsAs boundedFirst "{\"b\":1,\"c\":1}" (lacks "a")
  putStrLn "PASS common required-shape reader holds patterns, notAll, minMembers and names in order"

main :: IO ()
main = do
  setFileSystemEncoding utf8
  hSetBuffering stdout LineBuffering
  args <- getArgs
  case args of
    ["--store-writer", filename, key] -> storeWriter filename (T.pack key)
    [root] -> runCases root
    _ -> ioError (userError "expected repository root or a native store peer")

runCases :: FilePath -> IO ()
runCases root = do
  busLogCases root
  identityCases root
  annotationCases root
  stateUnitCases root
  flowCases root
  actorCases root
  runtimeCases
  lifetimeCases
  cacheCases
  saveClock <- cacheClockCases root
  httpClock <- httpClockCases root
  SchemaCases.schemaCases
  let noSpace = Object (KM.fromList [("type", String "string"), ("pattern", String "^\\S+$")])
      dot = Object (KM.fromList [("type", String "string"), ("pattern", String "^x.+z$")])
  forM_ ["\xa0", "\x2028", "\xfeff"] $ \separator ->
    require "ECMAScript whitespace accepted by non-space pattern" (isLeft (validate schemas noSpace (String ("x" <> separator))))
  forM_ ["\n", "\r", "\x2028", "\x2029"] $ \separator ->
    require "ECMAScript dot matched line terminator" (isLeft (validate schemas dot (String ("x" <> separator <> "z"))))
  schemaCases root
  enumerationValueCases
  specification <- readJSON (root </> "protocol/specs/src/openapi.json")
  forM_ (KM.keys (object (at "schemas" (at "components" specification)))) $ \key -> do
    let name = Key.toText key
    shape <- maybe (ioError (userError "missing native schema for common required-shape proof")) pure (Map.lookup name schemas)
    value <- either (ioError . userError) pure (sample 0 shape)
    require
      ("common required shape refused native sample: " ++ T.unpack name ++ " " ++ show (Required.faultOf name value))
      (Required.faultOf name value == Nothing)
  putStrLn "PASS common required-shape reader accepts every generated component sample"
  requiredWalkerCases
  putStrLn "PASS generated schema samples, null presence, open members, exact numbers and enums"
  resourceCases root
  frameCases root
  shapeCases root
  textCases root
  tokenStorageCases root
  signInStoreCases root
  clientAssertionCases root
  identifierCases root
  putStrLn "PASS shared identifier acceptance/refusal cases"
  tableCases root
  putStrLn "PASS every carried table as Protocol states it"
  channelCases root
  factCases root
  retryCases root
  metadata <-
    either (ioError . userError) pure (sample 0 (Object (KM.singleton "$ref" (String "JobMetadata.json"))))
      >>= either (ioError . userError) pure . parseEither parseJSON
  workerCases root metadata
  gatewayCases root
  kb <-
    either (ioError . userError) pure (sample 0 (Object (KM.singleton "$ref" (String "DiscoveredKB.json"))))
      >>= either (ioError . userError) pure . parseEither parseJSON
  document <-
    either (ioError . userError) pure (sample 0 (Object (KM.singleton "$ref" (String "DiscoveryDocument.json"))))
      >>= either (ioError . userError) pure . parseEither parseJSON
  discoveryCases kb document
  httpDiscoveryCases document
  discoveryClock <- discoveryClockCases root kb
  command <-
    either (ioError . userError) pure (sample 0 (Object (KM.singleton "$ref" (String "FrameAddEntityTypeCommand.json"))))
      >>= either (ioError . userError) pure . parseEither parseJSON
  event <- either (ioError . userError) pure (sample 0 (Object (KM.singleton "$ref" (String "EnrichedResourceEvent.json"))))
  browse <-
    either (ioError . userError) pure (sample 0 (Object (KM.singleton "$ref" (String "BrowseResourceRequest.json"))))
      >>= either (ioError . userError) pure . parseEither parseJSON
  errorTable <- readJSON (root </> "protocol/specs/src/errors/codes.json")
  let busErrors = at "busRequest" errorTable
  fallback <- either (ioError . userError) pure (parseEither parseJSON (at "unrecognizedFailure" busErrors))
  failureRows <- forM [row | row <- array (at "codes" busErrors), String _ <- [at "wire" row]] $ \row -> do
    wire <- either (ioError . userError) pure (parseEither parseJSON (at "wire" row))
    code <- either (ioError . userError) pure (parseEither parseJSON (at "code" row))
    pure (Just wire, code, Just wire)
  busCases command browse event (failureRows ++ [(Nothing, fallback, Nothing), (Just "__unknown_test_code", fallback, Nothing)])
  fixtures <- traverse (either (ioError . userError) pure . sample 0) schemas
  registryRuntimeCases fixtures
  testingCases fixtures
  registryCases root fixtures
  openResourceCases root fixtures
  registryErrorsCases root fixtures
  persistenceCases fixtures
  cacheDocumentCases root
  persistedCases root fixtures
  issuerCases fixtures
  serviceTokenCases root
  deviceClock <- deviceClockCases root
  sessionCases root fixtures
  sessionClock <- sessionClockCases root fixtures
  delegationCases fixtures
  followerClock <- followerClockCases root fixtures
  surfaceCases root fixtures
  clientClock <- clientClockCases root fixtures
  jobPollClock <- jobPollClockCases root fixtures
  refreshCases fixtures
  heldCases fixtures
  heldClock <- heldClockCases root fixtures
  clockCensus root (concat [saveClock, httpClock, discoveryClock, deviceClock, sessionClock, followerClock, clientClock, jobPollClock, heldClock])
  httpCases root fixtures
  corpusCases root
