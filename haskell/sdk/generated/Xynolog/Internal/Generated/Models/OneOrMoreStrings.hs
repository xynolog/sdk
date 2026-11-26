-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.OneOrMoreStrings (OneOrMoreStrings (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data OneOrMoreStrings = OneOrMoreStringsText Text | OneOrMoreStringsList [Text] deriving (Eq, Show)

instance FromJSON OneOrMoreStrings where parseJSON = checked "OneOrMoreStrings" $ \value -> readMember "OneOrMoreStrings" [([Signature {signatureKind = TextKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], OneOrMoreStringsText <$> parseJSON value), ([Signature {signatureKind = ListKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], OneOrMoreStringsList <$> parseJSON value)] value

instance ToJSON OneOrMoreStrings where
  toJSON (OneOrMoreStringsText value) = toJSON value
  toJSON (OneOrMoreStringsList value) = toJSON value
