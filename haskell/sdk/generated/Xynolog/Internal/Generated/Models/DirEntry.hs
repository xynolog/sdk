-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DirEntry (DirEntry (..), DirEntryType (..), dirEntryTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data DirEntry = DirEntry
  { dirEntryMtime :: Text,
    dirEntryName :: Text,
    dirEntryPath :: Text,
    dirEntryType :: DirEntryType
  }
  deriving (Eq, Show)

instance FromJSON DirEntry where parseJSON = checked "DirEntry" $ withObject "DirEntry" (\fields -> DirEntry <$> (fields .: "mtime") <*> (fields .: "name") <*> (fields .: "path") <*> (fields .: "type"))

instance ToJSON DirEntry where toJSON value = Object (KM.fromList (concat [[("mtime", toJSON (dirEntryMtime value))], [("name", toJSON (dirEntryName value))], [("path", toJSON (dirEntryPath value))], [("type", toJSON (dirEntryType value))]]))

data DirEntryType = DirEntryTypeDir deriving (Eq, Show)

instance FromJSON DirEntryType where parseJSON = checked "DirEntryType" $ \value -> if value == String "dir" then pure DirEntryTypeDir else fail "unknown enumeration member"

instance ToJSON DirEntryType where toJSON DirEntryTypeDir = String "dir"

dirEntryTypeText :: DirEntryType -> Text
dirEntryTypeText DirEntryTypeDir = "dir"
