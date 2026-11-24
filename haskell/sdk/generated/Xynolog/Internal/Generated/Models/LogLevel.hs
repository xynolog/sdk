-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LogLevel (LogLevel (..), logLevelText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data LogLevel = LogLevelError | LogLevelWarn | LogLevelInfo | LogLevelHttp | LogLevelDebug deriving (Eq, Show)

instance FromJSON LogLevel where parseJSON = checked "LogLevel" $ \value -> if value == String "error" then pure LogLevelError else if value == String "warn" then pure LogLevelWarn else if value == String "info" then pure LogLevelInfo else if value == String "http" then pure LogLevelHttp else if value == String "debug" then pure LogLevelDebug else fail "unknown enumeration member"

instance ToJSON LogLevel where
  toJSON LogLevelError = String "error"
  toJSON LogLevelWarn = String "warn"
  toJSON LogLevelInfo = String "info"
  toJSON LogLevelHttp = String "http"
  toJSON LogLevelDebug = String "debug"

logLevelText :: LogLevel -> Text
logLevelText LogLevelError = "error"
logLevelText LogLevelWarn = "warn"
logLevelText LogLevelInfo = "info"
logLevelText LogLevelHttp = "http"
logLevelText LogLevelDebug = "debug"
