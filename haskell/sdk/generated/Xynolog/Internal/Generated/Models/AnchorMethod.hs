-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchorMethod (AnchorMethod (..), anchorMethodText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data AnchorMethod = AnchorMethodUniqueMatch | AnchorMethodContextRecovered | AnchorMethodFirstOfMany | AnchorMethodFuzzyMatch deriving (Eq, Show)

instance FromJSON AnchorMethod where parseJSON = checked "AnchorMethod" $ \value -> if value == String "unique-match" then pure AnchorMethodUniqueMatch else if value == String "context-recovered" then pure AnchorMethodContextRecovered else if value == String "first-of-many" then pure AnchorMethodFirstOfMany else if value == String "fuzzy-match" then pure AnchorMethodFuzzyMatch else fail "unknown enumeration member"

instance ToJSON AnchorMethod where
  toJSON AnchorMethodUniqueMatch = String "unique-match"
  toJSON AnchorMethodContextRecovered = String "context-recovered"
  toJSON AnchorMethodFirstOfMany = String "first-of-many"
  toJSON AnchorMethodFuzzyMatch = String "fuzzy-match"

anchorMethodText :: AnchorMethod -> Text
anchorMethodText AnchorMethodUniqueMatch = "unique-match"
anchorMethodText AnchorMethodContextRecovered = "context-recovered"
anchorMethodText AnchorMethodFirstOfMany = "first-of-many"
anchorMethodText AnchorMethodFuzzyMatch = "fuzzy-match"
