-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LogFormat (LogFormat (..), logFormatText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data LogFormat = LogFormatJson | LogFormatSimple deriving (Eq, Show)

instance FromJSON LogFormat where parseJSON = checked "LogFormat" $ \value -> if value == String "json" then pure LogFormatJson else if value == String "simple" then pure LogFormatSimple else fail "unknown enumeration member"

instance ToJSON LogFormat where
  toJSON LogFormatJson = String "json"
  toJSON LogFormatSimple = String "simple"

logFormatText :: LogFormat -> Text
logFormatText LogFormatJson = "json"
logFormatText LogFormatSimple = "simple"
