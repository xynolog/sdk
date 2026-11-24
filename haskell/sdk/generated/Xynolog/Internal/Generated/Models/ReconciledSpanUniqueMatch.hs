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
    reconciledSpanUniqueMatchEnd :: Integer,
    reconciledSpanUniqueMatchExact :: Text,
    reconciledSpanUniqueMatchPrefix :: Maybe Text,
    reconciledSpanUniqueMatchStart :: Integer,
    reconciledSpanUniqueMatchSuffix :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ReconciledSpanUniqueMatch where parseJSON = checked "ReconciledSpanUniqueMatch" $ withObject "ReconciledSpanUniqueMatch" (\fields -> ReconciledSpanUniqueMatch <$> (fields .: "anchorMethod") <*> (fields .: "end") <*> (fields .: "exact") <*> optional fields "prefix" <*> (fields .: "start") <*> optional fields "suffix")

instance ToJSON ReconciledSpanUniqueMatch where toJSON value = Object (KM.fromList (concat [[("anchorMethod", toJSON (reconciledSpanUniqueMatchAnchorMethod value))], [("end", toJSON (reconciledSpanUniqueMatchEnd value))], [("exact", toJSON (reconciledSpanUniqueMatchExact value))], optionalPair "prefix" (reconciledSpanUniqueMatchPrefix value), [("start", toJSON (reconciledSpanUniqueMatchStart value))], optionalPair "suffix" (reconciledSpanUniqueMatchSuffix value)]))

data ReconciledSpanUniqueMatchAnchorMethod = ReconciledSpanUniqueMatchAnchorMethodUniqueU2d_match deriving (Eq, Show)

instance FromJSON ReconciledSpanUniqueMatchAnchorMethod where parseJSON = checked "ReconciledSpanUniqueMatchAnchorMethod" $ \value -> if value == String "unique-match" then pure ReconciledSpanUniqueMatchAnchorMethodUniqueU2d_match else fail "unknown enumeration member"

instance ToJSON ReconciledSpanUniqueMatchAnchorMethod where toJSON ReconciledSpanUniqueMatchAnchorMethodUniqueU2d_match = String "unique-match"

reconciledSpanUniqueMatchAnchorMethodText :: ReconciledSpanUniqueMatchAnchorMethod -> Text
reconciledSpanUniqueMatchAnchorMethodText ReconciledSpanUniqueMatchAnchorMethodUniqueU2d_match = "unique-match"
