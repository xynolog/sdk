{-# LANGUAGE OverloadedStrings #-}

-- | Launcher discovery is a whole document: an absent launcher differs from
-- a launcher managing no knowledge bases. Reads never sign anyone in.
module Xynolog.Discovery
  ( DiscoveryTransport (..),
    DiscoveryOptions (..),
    InvalidDiscoveryInterval (..),
    parseDiscoveryDocument,
    textDiscovery,
    discoveryDiff,
    subscribeDiscovery,
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
import Xynolog.Types
  ( DiscoveredKB (..),
    DiscoveryAbsent (..),
    DiscoveryAbsentKind (..),
    DiscoveryAbsentReason (..),
    DiscoveryDiff (..),
    DiscoveryDocument (..),
    DiscoveryDocumentVersion,
    DiscoveryManaged (..),
    DiscoveryManagedKind (..),
    DiscoveryRead (..),
    DiscoveryState (..),
  )

newtype DiscoveryTransport = DiscoveryTransport {readDiscovery :: IO DiscoveryRead}

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
  Left diagnostic -> absent DiscoveryAbsentReasonNotJson (Just (T.pack diagnostic))
  Right value@(Object fields) -> case KM.lookup "version" fields of
    Just version@(Number number) -> case floatingOrInteger number :: Either Double Integer of
      Left _ -> invalid "version is not an integer"
      Right _ -> case parseEither parseJSON version :: Either String DiscoveryDocumentVersion of
        Left _ -> absent DiscoveryAbsentReasonUnsupportedVersion (Just "unsupported discovery document version")
        Right _ -> case parseEither parseJSON value of
          Left diagnostic -> invalid (T.pack diagnostic)
          Right document ->
            let kbs = discoveryDocumentKbs document
             in if all (\kb -> discoveredKBPort kb >= 1 && discoveredKBPort kb <= 65535) kbs
                  then DiscoveryStateDiscoveryManaged (DiscoveryManaged DiscoveryManagedKindManaged kbs)
                  else invalid "knowledge-base port is outside the TCP port range"
    _ -> invalid "missing integer version"
  Right _ -> invalid "document is not an object"
  where
    invalid diagnostic = absent DiscoveryAbsentReasonInvalid (Just diagnostic)

absent :: DiscoveryAbsentReason -> Maybe Text -> DiscoveryState
absent reason diagnostic = DiscoveryStateDiscoveryAbsent (DiscoveryAbsent DiscoveryAbsentKindAbsent reason diagnostic)

readOf :: DiscoveryState -> DiscoveryRead
readOf (DiscoveryStateDiscoveryAbsent found) = DiscoveryReadDiscoveryAbsent found
readOf (DiscoveryStateDiscoveryManaged found) = DiscoveryReadDiscoveryManaged found

stateOf :: DiscoveryRead -> Maybe DiscoveryState
stateOf (DiscoveryReadDiscoveryAbsent found) = Just (DiscoveryStateDiscoveryAbsent found)
stateOf (DiscoveryReadDiscoveryManaged found) = Just (DiscoveryStateDiscoveryManaged found)
stateOf (DiscoveryReadDiscoveryUnchanged _) = Nothing

textDiscovery :: IO Text -> DiscoveryTransport
textDiscovery readText =
  DiscoveryTransport $
    (readOf . parseDiscoveryDocument <$> readText) `catch` fileFailure `catch` unicodeFailure
  where
    fileFailure :: IOException -> IO DiscoveryRead
    fileFailure exception =
      pure
        ( readOf
            ( absent
                (if isDoesNotExistError exception then DiscoveryAbsentReasonNotFound else DiscoveryAbsentReasonUnreadable)
                (Just (T.pack (displayException exception)))
            )
        )
    unicodeFailure :: UnicodeException -> IO DiscoveryRead
    unicodeFailure exception = pure (readOf (absent DiscoveryAbsentReasonUnreadable (Just (T.pack (displayException exception)))))

entries :: Maybe DiscoveryState -> [DiscoveredKB]
entries (Just (DiscoveryStateDiscoveryManaged managed)) = discoveryManagedKbs managed
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
    then
      Just
        DiscoveryDiff
          { discoveryDiffState = current,
            discoveryDiffAdded = inserted,
            discoveryDiffUpdated = changed,
            discoveryDiffRemoved = deleted,
            discoveryDiffDuplicated = duplicates
          }
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
      (Just (DiscoveryStateDiscoveryManaged _), DiscoveryStateDiscoveryManaged _) -> False
      (Just (DiscoveryStateDiscoveryAbsent beforeAbsent), DiscoveryStateDiscoveryAbsent afterAbsent) ->
        discoveryAbsentReason beforeAbsent /= discoveryAbsentReason afterAbsent
      _ -> True

subscribeDiscovery :: DiscoveryOptions -> DiscoveryTransport -> Stream (Of DiscoveryDiff) IO ()
subscribeDiscovery options transport = do
  liftIO (when (discoveryIntervalMs options <= 0) (throwIO InvalidDiscoveryInterval))
  loop Nothing
  where
    loop previous = do
      observation <- liftIO (readDiscovery transport)
      next <- case stateOf observation of
        Nothing -> pure previous
        Just current -> case discoveryDiff previous current of
          Nothing -> pure previous
          Just change -> Stream.yield change >> pure (Just current)
      now <- liftIO (discoveryNow options)
      liftIO (discoveryWaitUntil options (now + discoveryIntervalMs options * 1000000))
      loop next
