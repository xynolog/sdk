-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.CacheStatus (CacheStatus (..), cacheStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data CacheStatus = CacheStatusPending | CacheStatusReady | CacheStatusFailed deriving (Eq, Show)

instance FromJSON CacheStatus where parseJSON = checked "CacheStatus" $ \value -> if value == String "pending" then pure CacheStatusPending else if value == String "ready" then pure CacheStatusReady else if value == String "failed" then pure CacheStatusFailed else fail "unknown enumeration member"

instance ToJSON CacheStatus where
  toJSON CacheStatusPending = String "pending"
  toJSON CacheStatusReady = String "ready"
  toJSON CacheStatusFailed = String "failed"

cacheStatusText :: CacheStatus -> Text
cacheStatusText CacheStatusPending = "pending"
cacheStatusText CacheStatusReady = "ready"
cacheStatusText CacheStatusFailed = "failed"
