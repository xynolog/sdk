-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DirectoryEntry (DirectoryEntry (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DirEntry
import Xynolog.Internal.Generated.Models.FileEntry

data DirectoryEntry = DirectoryEntryFileEntry FileEntry | DirectoryEntryDirEntry DirEntry deriving (Eq, Show)

instance FromJSON DirectoryEntry where parseJSON = checked "DirectoryEntry" $ \value -> readMember "DirectoryEntry" [([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "name", "path", "size", "mtime", "tracked"], signatureAllowed = Just ["type", "name", "path", "size", "mtime", "tracked", "resourceId", "entityTypes", "annotationCount", "creator"], signatureFixed = [("type", [String "file"])], signaturePattern = Nothing, signatureValues = Nothing}], DirectoryEntryFileEntry <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "name", "path", "mtime"], signatureAllowed = Just ["type", "name", "path", "mtime"], signatureFixed = [("type", [String "dir"])], signaturePattern = Nothing, signatureValues = Nothing}], DirectoryEntryDirEntry <$> parseJSON value)] value

instance ToJSON DirectoryEntry where
  toJSON (DirectoryEntryFileEntry value) = toJSON value
  toJSON (DirectoryEntryDirEntry value) = toJSON value
