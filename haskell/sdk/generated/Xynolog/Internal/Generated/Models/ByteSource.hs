-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ByteSource (ByteSource (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.ByteString (ByteString)
import Xynolog.Internal.Codec

newtype ByteSource = ByteSource {byteSourceValue :: ByteString} deriving (Eq, Show)

instance FromJSON ByteSource where parseJSON = checked "ByteSource" $ \value -> ByteSource <$> base64Bytes value

instance ToJSON ByteSource where toJSON (ByteSource value) = base64Value value
