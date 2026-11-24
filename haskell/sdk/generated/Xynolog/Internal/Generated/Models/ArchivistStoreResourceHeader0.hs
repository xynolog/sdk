-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistStoreResourceHeader0 (ArchivistStoreResourceHeader0 (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

newtype ArchivistStoreResourceHeader0 = ArchivistStoreResourceHeader0 {archivistStoreResourceHeader0Value :: Text} deriving (Eq, Show)

instance FromJSON ArchivistStoreResourceHeader0 where parseJSON = checked "ArchivistStoreResourceHeader0" $ \value -> ArchivistStoreResourceHeader0 <$> parseJSON value

instance ToJSON ArchivistStoreResourceHeader0 where toJSON (ArchivistStoreResourceHeader0 value) = toJSON value
