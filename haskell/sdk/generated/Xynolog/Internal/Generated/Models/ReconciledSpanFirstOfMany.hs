-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ReconciledSpanFirstOfMany (ReconciledSpanFirstOfMany (..), ReconciledSpanFirstOfManyAnchorMethod (..), reconciledSpanFirstOfManyAnchorMethodText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ReconciledSpanFirstOfMany = ReconciledSpanFirstOfMany
  { reconciledSpanFirstOfManyAnchorMethod :: ReconciledSpanFirstOfManyAnchorMethod,
    reconciledSpanFirstOfManyEnd :: Integer,
    reconciledSpanFirstOfManyExact :: Text,
    reconciledSpanFirstOfManyPrefix :: Maybe Text,
    reconciledSpanFirstOfManyStart :: Integer,
    reconciledSpanFirstOfManySuffix :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ReconciledSpanFirstOfMany where parseJSON = checked "ReconciledSpanFirstOfMany" $ withObject "ReconciledSpanFirstOfMany" (\fields -> ReconciledSpanFirstOfMany <$> (fields .: "anchorMethod") <*> (fields .: "end") <*> (fields .: "exact") <*> optional fields "prefix" <*> (fields .: "start") <*> optional fields "suffix")

instance ToJSON ReconciledSpanFirstOfMany where toJSON value = Object (KM.fromList (concat [[("anchorMethod", toJSON (reconciledSpanFirstOfManyAnchorMethod value))], [("end", toJSON (reconciledSpanFirstOfManyEnd value))], [("exact", toJSON (reconciledSpanFirstOfManyExact value))], optionalPair "prefix" (reconciledSpanFirstOfManyPrefix value), [("start", toJSON (reconciledSpanFirstOfManyStart value))], optionalPair "suffix" (reconciledSpanFirstOfManySuffix value)]))

data ReconciledSpanFirstOfManyAnchorMethod = ReconciledSpanFirstOfManyAnchorMethodFirstOfMany deriving (Eq, Show)

instance FromJSON ReconciledSpanFirstOfManyAnchorMethod where parseJSON = checked "ReconciledSpanFirstOfManyAnchorMethod" $ \value -> if value == String "first-of-many" then pure ReconciledSpanFirstOfManyAnchorMethodFirstOfMany else fail "unknown enumeration member"

instance ToJSON ReconciledSpanFirstOfManyAnchorMethod where toJSON ReconciledSpanFirstOfManyAnchorMethodFirstOfMany = String "first-of-many"

reconciledSpanFirstOfManyAnchorMethodText :: ReconciledSpanFirstOfManyAnchorMethod -> Text
reconciledSpanFirstOfManyAnchorMethodText ReconciledSpanFirstOfManyAnchorMethodFirstOfMany = "first-of-many"
