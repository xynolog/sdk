-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ReconciledSpanUniqueMatch (ReconciledSpanUniqueMatch (..), ReconciledSpanUniqueMatchAnchorMethod (..), reconciledSpanUniqueMatchAnchorMethodText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ReconciledSpanUniqueMatch = ReconciledSpanUniqueMatch
  { reconciledSpanUniqueMatchAnchorMethod :: ReconciledSpanUniqueMatchAnchorMethod,
    reconciledSpanUniqueMatchStart :: Integer,
    reconciledSpanUniqueMatchEnd :: Integer,
    reconciledSpanUniqueMatchExact :: Text,
    reconciledSpanUniqueMatchPrefix :: Maybe Text,
    reconciledSpanUniqueMatchSuffix :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ReconciledSpanUniqueMatch where parseJSON = checked "ReconciledSpanUniqueMatch" $ withObject "ReconciledSpanUniqueMatch" (\fields -> ReconciledSpanUniqueMatch <$> (fields .: "anchorMethod") <*> (fields .: "start") <*> (fields .: "end") <*> (fields .: "exact") <*> optional fields "prefix" <*> optional fields "suffix")

instance ToJSON ReconciledSpanUniqueMatch where toJSON value = Object (KM.fromList (concat [[("anchorMethod", toJSON (reconciledSpanUniqueMatchAnchorMethod value))], [("start", toJSON (reconciledSpanUniqueMatchStart value))], [("end", toJSON (reconciledSpanUniqueMatchEnd value))], [("exact", toJSON (reconciledSpanUniqueMatchExact value))], optionalPair "prefix" (reconciledSpanUniqueMatchPrefix value), optionalPair "suffix" (reconciledSpanUniqueMatchSuffix value)]))

data ReconciledSpanUniqueMatchAnchorMethod = ReconciledSpanUniqueMatchAnchorMethodUniqueMatch deriving (Eq, Show)

instance FromJSON ReconciledSpanUniqueMatchAnchorMethod where parseJSON = checked "ReconciledSpanUniqueMatchAnchorMethod" $ \value -> if value == String "unique-match" then pure ReconciledSpanUniqueMatchAnchorMethodUniqueMatch else fail "unknown enumeration member"

instance ToJSON ReconciledSpanUniqueMatchAnchorMethod where toJSON ReconciledSpanUniqueMatchAnchorMethodUniqueMatch = String "unique-match"

reconciledSpanUniqueMatchAnchorMethodText :: ReconciledSpanUniqueMatchAnchorMethod -> Text
reconciledSpanUniqueMatchAnchorMethodText ReconciledSpanUniqueMatchAnchorMethodUniqueMatch = "unique-match"
