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
  { fileEntryType :: FileEntryType,
    fileEntryName :: Text,
    fileEntryPath :: Text,
    fileEntrySize :: Integer,
    fileEntryMtime :: Text,
    fileEntryTracked :: Bool,
    fileEntryResourceId :: Maybe ResourceId,
    fileEntryEntityTypes :: Maybe [Text],
    fileEntryAnnotationCount :: Maybe Integer,
    fileEntryCreator :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON FileEntry where parseJSON = checked "FileEntry" $ withObject "FileEntry" (\fields -> FileEntry <$> (fields .: "type") <*> (fields .: "name") <*> (fields .: "path") <*> (fields .: "size") <*> (fields .: "mtime") <*> (fields .: "tracked") <*> optional fields "resourceId" <*> optional fields "entityTypes" <*> optional fields "annotationCount" <*> optional fields "creator")

instance ToJSON FileEntry where toJSON value = Object (KM.fromList (concat [[("type", toJSON (fileEntryType value))], [("name", toJSON (fileEntryName value))], [("path", toJSON (fileEntryPath value))], [("size", toJSON (fileEntrySize value))], [("mtime", toJSON (fileEntryMtime value))], [("tracked", toJSON (fileEntryTracked value))], optionalPair "resourceId" (fileEntryResourceId value), optionalPair "entityTypes" (fileEntryEntityTypes value), optionalPair "annotationCount" (fileEntryAnnotationCount value), optionalPair "creator" (fileEntryCreator value)]))

data FileEntryType = FileEntryTypeFile deriving (Eq, Show)

instance FromJSON FileEntryType where parseJSON = checked "FileEntryType" $ \value -> if value == String "file" then pure FileEntryTypeFile else fail "unknown enumeration member"

instance ToJSON FileEntryType where toJSON FileEntryTypeFile = String "file"

fileEntryTypeText :: FileEntryType -> Text
fileEntryTypeText FileEntryTypeFile = "file"
