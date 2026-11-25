-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.OneOrMoreUris (OneOrMoreUris (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data OneOrMoreUris = OneOrMoreUrisText Text | OneOrMoreUrisList [Text] deriving (Eq, Show)

instance FromJSON OneOrMoreUris where parseJSON = checked "OneOrMoreUris" $ \value -> readMember "OneOrMoreUris" [([Signature {signatureKind = TextKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], OneOrMoreUrisText <$> parseJSON value), ([Signature {signatureKind = ListKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], OneOrMoreUrisList <$> parseJSON value)] value

instance ToJSON OneOrMoreUris where
  toJSON (OneOrMoreUrisText value) = toJSON value
  toJSON (OneOrMoreUrisList value) = toJSON value
