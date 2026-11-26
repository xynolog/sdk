{-# LANGUAGE OverloadedStrings #-}

-- | Launcher discovery is a whole document: an absent launcher differs from
-- a launcher managing no knowledge bases. Reads never sign anyone in.
module Xynolog.Discovery
  ( DiscoveryState (..),
    DiscoveryRead (..),
    DiscoveryDiff (..),
    DiscoveryTransport (..),
    DiscoveryOptions (..),
    InvalidDiscoveryInterval (..),
    parseDiscoveryDocument,
    textDiscovery,
    discoveryDiff,
    subscribeDiscovery,
    module Xynolog.Discovery.Reasons,
  )
where

import Control.Exception (Exception, IOException, catch, displayException, throwIO)
import Control.Monad (when)
import Control.Monad.IO.Class (liftIO)
import Data.Aeson (Value (..), eitherDecodeStrict', parseJSON)
import Data.Aeson.KeyMap qualified as KM
import Data.Aeson.Types (parseEither)
import Data.List (delete)
import Data.Map.Strict qualified as Map
import Data.Scientific (floatingOrInteger)
import Data.Set qualified as Set
import Data.Text (Text)
import Data.Text qualified as T
import Data.Text.Encoding (encodeUtf8)
import Data.Text.Encoding.Error (UnicodeException)
import Streaming (Of, Stream)
import Streaming.Prelude qualified as Stream
import System.IO.Error (isDoesNotExistError)
import Xynolog.Discovery.Reasons
import Xynolog.Internal.Required (faultOf, faultSaid)
import Xynolog.Types (DiscoveredKB (..), DiscoveryDocument (..), DiscoveryDocumentVersion)

data DiscoveryState = Absent DiscoveryAbsentCode (Maybe Text) | Managed [DiscoveredKB] deriving (Eq, Show)

data DiscoveryRead = Read DiscoveryState | Unchanged deriving (Eq, Show)

newtype DiscoveryTransport = DiscoveryTransport {readDiscovery :: IO DiscoveryRead}

data DiscoveryDiff = DiscoveryDiff
  { state :: DiscoveryState,
    added :: [DiscoveredKB],
    updated :: [DiscoveredKB],
    removed :: [DiscoveredKB],
    duplicated :: [Text]
  }
  deriving (Eq, Show)

data DiscoveryOptions = DiscoveryOptions
  { -- | Monotonic nanoseconds in the same coordinate system as the wait.
    discoveryNow :: IO Integer,
    -- | An interruptible wait until the absolute monotonic nanosecond deadline.
    discoveryWaitUntil :: Integer -> IO (),
    discoveryIntervalMs :: Integer
  }

data InvalidDiscoveryInterval = InvalidDiscoveryInterval deriving (Eq, Show)

instance Exception InvalidDiscoveryInterval

parseDiscoveryDocument :: Text -> DiscoveryState
parseDiscoveryDocument raw = case eitherDecodeStrict' (encodeUtf8 raw) of
  Left diagnostic -> Absent DiscoveryAbsentNotJson (Just (T.pack diagnostic))
  Right value@(Object fields) -> case KM.lookup "version" fields of
    Just version@(Number number) -> case floatingOrInteger number :: Either Double Integer of
      Left _ -> invalid "version is not an integer"
      Right _ -> case parseEither parseJSON version :: Either String DiscoveryDocumentVersion of
        Left _ -> Absent DiscoveryAbsentUnsupportedVersion (Just "unsupported discovery document version")
        Right _ -> case faultOf "DiscoveryDocument" value of
          Just fault -> invalid (faultSaid fault)
          Nothing -> case parseEither parseJSON value of
            Left diagnostic -> invalid (T.pack diagnostic)
            Right document -> Managed (discoveryDocumentKbs document)
    _ -> invalid "missing integer version"
  Right _ -> invalid "document is not an object"
  where
    invalid diagnostic = Absent DiscoveryAbsentInvalid (Just diagnostic)

textDiscovery :: IO Text -> DiscoveryTransport
textDiscovery readText =
  DiscoveryTransport $
    (Read . parseDiscoveryDocument <$> readText) `catch` fileFailure `catch` unicodeFailure
  where
    fileFailure :: IOException -> IO DiscoveryRead
    fileFailure exception =
      pure
        ( Read
            ( Absent
                (if isDoesNotExistError exception then DiscoveryAbsentNotFound else DiscoveryAbsentUnreadable)
                (Just (T.pack (displayException exception)))
            )
        )
    unicodeFailure :: UnicodeException -> IO DiscoveryRead
    unicodeFailure exception = pure (Read (Absent DiscoveryAbsentUnreadable (Just (T.pack (displayException exception)))))

entries :: Maybe DiscoveryState -> [DiscoveredKB]
entries (Just (Managed kbs)) = kbs
entries _ = []

address :: DiscoveredKB -> (Text, Integer)
address kb = (discoveredKBHost kb, discoveredKBPort kb)

-- Ignore document order while retaining every claim at a duplicated address.
sameEntries :: [DiscoveredKB] -> [DiscoveredKB] -> Bool
sameEntries [] values = null values
sameEntries (value : rest) values = value `elem` values && sameEntries rest (delete value values)

discoveryDiff :: Maybe DiscoveryState -> DiscoveryState -> Maybe DiscoveryDiff
discoveryDiff previous current =
  if stateChanged || not (null inserted && null changed && null deleted)
    then Just (DiscoveryDiff current inserted changed deleted duplicates)
    else Nothing
  where
    before = entries previous
    after = entries (Just current)
    group values = Map.fromListWith (++) [(address kb, [kb]) | kb <- values]
    was = group before
    now = group after
    inserted = [kb | kb <- after, Map.notMember (address kb) was]
    changed =
      [ kb
      | kb <- after,
        Just old <- [Map.lookup (address kb) was],
        Just new <- [Map.lookup (address kb) now],
        not (sameEntries old new)
      ]
    deleted = [kb | kb <- before, Map.notMember (address kb) now]
    duplicates = snd (foldl count (Set.empty, []) after)
    count (seen, listed) kb =
      let key@(host, port) = address kb
          rendered = host <> ":" <> T.pack (show port)
       in (Set.insert key seen, if Set.member key seen && rendered `notElem` listed then listed ++ [rendered] else listed)
    stateChanged = case (previous, current) of
      (Just (Managed _), Managed _) -> False
      (Just (Absent beforeReason _), Absent afterReason _) -> beforeReason /= afterReason
      _ -> True

subscribeDiscovery :: DiscoveryOptions -> DiscoveryTransport -> Stream (Of DiscoveryDiff) IO ()
subscribeDiscovery options transport = do
  liftIO (when (discoveryIntervalMs options <= 0) (throwIO InvalidDiscoveryInterval))
  loop Nothing
  where
    loop previous = do
      observation <- liftIO (readDiscovery transport)
      next <- case observation of
        Unchanged -> pure previous
        Read current -> case discoveryDiff previous current of
          Nothing -> pure previous
          Just change -> Stream.yield change >> pure (Just current)
      now <- liftIO (discoveryNow options)
      liftIO (discoveryWaitUntil options (now + discoveryIntervalMs options * 1000000))
      loop next
