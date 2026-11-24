-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistStoreResourceHeader2 (ArchivistStoreResourceHeader2 (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

newtype ArchivistStoreResourceHeader2 = ArchivistStoreResourceHeader2 {archivistStoreResourceHeader2Value :: Text} deriving (Eq, Show)

instance FromJSON ArchivistStoreResourceHeader2 where parseJSON = checked "ArchivistStoreResourceHeader2" $ \value -> ArchivistStoreResourceHeader2 <$> parseJSON value

instance ToJSON ArchivistStoreResourceHeader2 where toJSON (ArchivistStoreResourceHeader2 value) = toJSON value
