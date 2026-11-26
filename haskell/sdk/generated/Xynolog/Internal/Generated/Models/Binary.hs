-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Binary (Binary (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.ByteString (ByteString)
import Xynolog.Internal.Codec

newtype Binary = Binary {binaryValue :: ByteString} deriving (Eq, Show)

instance FromJSON Binary where parseJSON = checked "Binary" $ \value -> Binary <$> base64Bytes value

instance ToJSON Binary where toJSON (Binary value) = base64Value value
