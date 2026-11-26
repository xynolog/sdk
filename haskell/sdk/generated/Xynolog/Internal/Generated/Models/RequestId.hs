-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RequestId (RequestId (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data RequestId = RequestIdText Text | RequestIdInteger Integer deriving (Eq, Show)

instance FromJSON RequestId where parseJSON = checked "RequestId" $ \value -> readMember "RequestId" [([Signature {signatureKind = TextKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], RequestIdText <$> parseJSON value), ([Signature {signatureKind = IntegerKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], RequestIdInteger <$> parseJSON value)] value

instance ToJSON RequestId where
  toJSON (RequestIdText value) = toJSON value
  toJSON (RequestIdInteger value) = toJSON value
