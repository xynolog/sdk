-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryAbsentReason (DiscoveryAbsentReason (..), discoveryAbsentReasonText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data DiscoveryAbsentReason = DiscoveryAbsentReasonNotFound | DiscoveryAbsentReasonNotJson | DiscoveryAbsentReasonInvalid | DiscoveryAbsentReasonUnsupportedVersion | DiscoveryAbsentReasonUnreadable deriving (Eq, Show)

instance FromJSON DiscoveryAbsentReason where parseJSON = checked "DiscoveryAbsentReason" $ \value -> if value == String "not-found" then pure DiscoveryAbsentReasonNotFound else if value == String "not-json" then pure DiscoveryAbsentReasonNotJson else if value == String "invalid" then pure DiscoveryAbsentReasonInvalid else if value == String "unsupported-version" then pure DiscoveryAbsentReasonUnsupportedVersion else if value == String "unreadable" then pure DiscoveryAbsentReasonUnreadable else fail "unknown enumeration member"

instance ToJSON DiscoveryAbsentReason where
  toJSON DiscoveryAbsentReasonNotFound = String "not-found"
  toJSON DiscoveryAbsentReasonNotJson = String "not-json"
  toJSON DiscoveryAbsentReasonInvalid = String "invalid"
  toJSON DiscoveryAbsentReasonUnsupportedVersion = String "unsupported-version"
  toJSON DiscoveryAbsentReasonUnreadable = String "unreadable"

discoveryAbsentReasonText :: DiscoveryAbsentReason -> Text
discoveryAbsentReasonText DiscoveryAbsentReasonNotFound = "not-found"
discoveryAbsentReasonText DiscoveryAbsentReasonNotJson = "not-json"
discoveryAbsentReasonText DiscoveryAbsentReasonInvalid = "invalid"
discoveryAbsentReasonText DiscoveryAbsentReasonUnsupportedVersion = "unsupported-version"
discoveryAbsentReasonText DiscoveryAbsentReasonUnreadable = "unreadable"
