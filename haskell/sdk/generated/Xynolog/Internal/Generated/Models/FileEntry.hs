-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FileEntry (FileEntry (..), FileEntryType (..), fileEntryTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data FileEntry = FileEntry
  { fileEntryAnnotationCount :: Maybe Integer,
    fileEntryCreator :: Maybe Text,
    fileEntryEntityTypes :: Maybe [Text],
    fileEntryMtime :: Text,
    fileEntryName :: Text,
    fileEntryPath :: Text,
    fileEntryResourceId :: Maybe ResourceId,
    fileEntrySize :: Integer,
    fileEntryTracked :: Bool,
    fileEntryType :: FileEntryType
  }
  deriving (Eq, Show)

instance FromJSON FileEntry where parseJSON = checked "FileEntry" $ withObject "FileEntry" (\fields -> FileEntry <$> optional fields "annotationCount" <*> optional fields "creator" <*> optional fields "entityTypes" <*> (fields .: "mtime") <*> (fields .: "name") <*> (fields .: "path") <*> optional fields "resourceId" <*> (fields .: "size") <*> (fields .: "tracked") <*> (fields .: "type"))

instance ToJSON FileEntry where toJSON value = Object (KM.fromList (concat [optionalPair "annotationCount" (fileEntryAnnotationCount value), optionalPair "creator" (fileEntryCreator value), optionalPair "entityTypes" (fileEntryEntityTypes value), [("mtime", toJSON (fileEntryMtime value))], [("name", toJSON (fileEntryName value))], [("path", toJSON (fileEntryPath value))], optionalPair "resourceId" (fileEntryResourceId value), [("size", toJSON (fileEntrySize value))], [("tracked", toJSON (fileEntryTracked value))], [("type", toJSON (fileEntryType value))]]))

data FileEntryType = FileEntryTypeFile deriving (Eq, Show)

instance FromJSON FileEntryType where parseJSON = checked "FileEntryType" $ \value -> if value == String "file" then pure FileEntryTypeFile else fail "unknown enumeration member"

instance ToJSON FileEntryType where toJSON FileEntryTypeFile = String "file"

fileEntryTypeText :: FileEntryType -> Text
fileEntryTypeText FileEntryTypeFile = "file"
