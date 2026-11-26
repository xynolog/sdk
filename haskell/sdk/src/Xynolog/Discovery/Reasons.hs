-- Generated from protocol/specs/src/client/discovery-absent.json and protocol/specs/src/client/surface.json; do not edit.
-- Regenerate: make generate (codegen/lib/error_codes/haskell.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Discovery.Reasons (DiscoveryAbsentCode (..), discoveryAbsentCode, parseDiscoveryAbsentCode, discoveryUrlPath) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withText)
import Data.Text (Text)

data DiscoveryAbsentCode = DiscoveryAbsentNotFound | DiscoveryAbsentNotJson | DiscoveryAbsentInvalid | DiscoveryAbsentUnsupportedVersion | DiscoveryAbsentUnreadable deriving (Eq, Ord, Show, Enum, Bounded)

discoveryAbsentCode :: DiscoveryAbsentCode -> Text
discoveryAbsentCode DiscoveryAbsentNotFound = "not-found"
discoveryAbsentCode DiscoveryAbsentNotJson = "not-json"
discoveryAbsentCode DiscoveryAbsentInvalid = "invalid"
discoveryAbsentCode DiscoveryAbsentUnsupportedVersion = "unsupported-version"
discoveryAbsentCode DiscoveryAbsentUnreadable = "unreadable"

parseDiscoveryAbsentCode :: Text -> Maybe DiscoveryAbsentCode
parseDiscoveryAbsentCode value = case value of
  "not-found" -> Just DiscoveryAbsentNotFound
  "not-json" -> Just DiscoveryAbsentNotJson
  "invalid" -> Just DiscoveryAbsentInvalid
  "unsupported-version" -> Just DiscoveryAbsentUnsupportedVersion
  "unreadable" -> Just DiscoveryAbsentUnreadable
  _ -> Nothing

instance ToJSON DiscoveryAbsentCode where toJSON = String . discoveryAbsentCode

instance FromJSON DiscoveryAbsentCode where parseJSON = withText "DiscoveryAbsentCode" (\value -> maybe (fail "unknown error code") pure (parseDiscoveryAbsentCode value))

-- | Where a launcher's discovery document is: its path under the state home, and the URL path a browser fetches it at.
discoveryUrlPath :: Text
discoveryUrlPath = "/discovery/kbs.json"
