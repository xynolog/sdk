-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DirectoryEntry (DirectoryEntry (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DirEntry
import Xynolog.Internal.Generated.Models.FileEntry

data DirectoryEntry = DirectoryEntryFileEntry FileEntry | DirectoryEntryDirEntry DirEntry deriving (Eq, Show)

instance FromJSON DirectoryEntry where parseJSON = checked "DirectoryEntry" $ \value -> (DirectoryEntryFileEntry <$> parseJSON value) <|> (DirectoryEntryDirEntry <$> parseJSON value)

instance ToJSON DirectoryEntry where
  toJSON (DirectoryEntryFileEntry value) = toJSON value
  toJSON (DirectoryEntryDirEntry value) = toJSON value
