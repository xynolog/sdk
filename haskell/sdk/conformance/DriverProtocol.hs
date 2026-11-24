{-# LANGUAGE OverloadedStrings #-}

module DriverProtocol (Misuse (..), need, decode, optional, failure, answerValue, writeLine, readyLine, unsupportedLine, now, waitUntil) where

import Control.Concurrent (threadDelay)
import Control.Concurrent.Async (AsyncCancelled (..))
import Control.Exception (Exception, SomeException, fromException, throwIO, uninterruptibleMask_)
import Control.Monad (when)
import Data.Aeson hiding (decode)
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString.Lazy qualified as Lazy
import Data.Text qualified as Text
import GHC.Clock (getMonotonicTimeNSec)
import System.IO (hFlush, stdout)
import Xynolog.Delegation qualified as Delegation
import Xynolog.ErrorCodes qualified as Code
import Xynolog.Errors
import Xynolog.Types (ConformanceDriverLine (..), ConformanceDriverLineAbandonedValue (..), ConformanceDriverLineAbandonedValueAbandoned (..), ConformanceDriverLineFailedValue (..), ConformanceDriverLineMisuseValue (..), ConformanceDriverLineOkValue (..), ConformanceDriverLineReadyValue (..), ConformanceDriverLineReadyValueReady (..), ConformanceDriverLineUnsupportedValue (..), ConformanceDriverLineUnsupportedValueUnsupported (..), ConformanceFailure (..))
import Xynolog.Worker qualified as Worker

data Misuse = Misuse String deriving (Show)

instance Exception Misuse

need :: (FromJSON value) => Object -> Key -> IO value
need fields key = case KM.lookup key fields of
  Nothing -> throwIO (Misuse ("Missing argument " ++ show key))
  Just value -> decode value

decode :: (FromJSON value) => Value -> IO value
decode value = case fromJSON value of Error reason -> throwIO (Misuse reason); Success result -> pure result

optional :: (FromJSON value) => Object -> Key -> IO (Maybe value)
optional fields key = traverse decode (KM.lookup key fields)

failure :: SomeException -> Maybe ConformanceFailure
failure exception
  | Just problem <- fromException exception =
      Just (ConformanceFailure (Just (Code.transportCode (transportErrorCode problem))) (transportErrorMessage problem) Nothing (toInteger <$> httpStatus problem))
  | Just problem <- fromException exception =
      Just (ConformanceFailure (Just (Code.busRequestCode (busRequestErrorCode problem))) (busRequestErrorMessage problem) Nothing Nothing)
  | Just problem <- fromException exception =
      Just (ConformanceFailure (Just (Code.jobCode (Delegation.jobErrorCode problem))) (Text.pack (show problem)) (Delegation.jobErrorFailureClass problem) Nothing)
  | otherwise = Nothing

-- A line is written whole or not at all: a thread cancelled between a line's text and its newline would leave the
-- next line on the same one.
writeLine :: ConformanceDriverLine -> IO ()
writeLine line = uninterruptibleMask_ (Lazy.hPut stdout (encode line <> "\n") >> hFlush stdout)

readyLine :: ConformanceDriverLine
readyLine = ConformanceDriverLineReady (ConformanceDriverLineReadyValue ConformanceDriverLineReadyValueReadyTrue)

unsupportedLine :: Integer -> ConformanceDriverLine
unsupportedLine identifier = ConformanceDriverLineUnsupported (ConformanceDriverLineUnsupportedValue identifier ConformanceDriverLineUnsupportedValueUnsupportedTrue)

now :: IO Integer
now = toInteger <$> getMonotonicTimeNSec

waitUntil :: Integer -> IO ()
waitUntil due = do
  current <- now
  when (current < due) $ do
    threadDelay (fromInteger (min (toInteger (maxBound :: Int)) ((due - current + 999) `div` 1000)))
    waitUntil due

answerValue :: Integer -> Either SomeException Value -> Either SomeException ConformanceDriverLine
answerValue identifier outcome = case outcome of
  Right value -> Right (ConformanceDriverLineOk (ConformanceDriverLineOkValue identifier value))
  Left problem
    | Just issue <- (fromException problem :: Maybe Worker.WorkerError) -> Right (misuse (Text.pack (show issue)))
    | Just (Misuse reason) <- fromException problem -> Right (misuse (Text.pack reason))
    | Just AsyncCancelled <- fromException problem -> Right (ConformanceDriverLineAbandoned (ConformanceDriverLineAbandonedValue ConformanceDriverLineAbandonedValueAbandonedTrue identifier))
    | Just value <- failure problem -> Right (ConformanceDriverLineFailed (ConformanceDriverLineFailedValue value identifier))
    | otherwise -> Left problem
  where
    misuse reason = ConformanceDriverLineMisuse (ConformanceDriverLineMisuseValue identifier reason)
