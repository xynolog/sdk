-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchorMethod (AnchorMethod (..), anchorMethodText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data AnchorMethod = AnchorMethodUniqueU2d_match | AnchorMethodContextU2d_recovered | AnchorMethodFirstU2d_ofU2d_many | AnchorMethodFuzzyU2d_match deriving (Eq, Show)

instance FromJSON AnchorMethod where parseJSON = checked "AnchorMethod" $ \value -> if value == String "unique-match" then pure AnchorMethodUniqueU2d_match else if value == String "context-recovered" then pure AnchorMethodContextU2d_recovered else if value == String "first-of-many" then pure AnchorMethodFirstU2d_ofU2d_many else if value == String "fuzzy-match" then pure AnchorMethodFuzzyU2d_match else fail "unknown enumeration member"

instance ToJSON AnchorMethod where
  toJSON AnchorMethodUniqueU2d_match = String "unique-match"
  toJSON AnchorMethodContextU2d_recovered = String "context-recovered"
  toJSON AnchorMethodFirstU2d_ofU2d_many = String "first-of-many"
  toJSON AnchorMethodFuzzyU2d_match = String "fuzzy-match"

anchorMethodText :: AnchorMethod -> Text
anchorMethodText AnchorMethodUniqueU2d_match = "unique-match"
anchorMethodText AnchorMethodContextU2d_recovered = "context-recovered"
anchorMethodText AnchorMethodFirstU2d_ofU2d_many = "first-of-many"
anchorMethodText AnchorMethodFuzzyU2d_match = "fuzzy-match"
