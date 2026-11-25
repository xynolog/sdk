-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DirEntry (DirEntry (..), DirEntryType (..), dirEntryTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data DirEntry = DirEntry
  { dirEntryType :: DirEntryType,
    dirEntryName :: Text,
    dirEntryPath :: Text,
    dirEntryMtime :: Text
  }
  deriving (Eq, Show)

instance FromJSON DirEntry where parseJSON = checked "DirEntry" $ withObject "DirEntry" (\fields -> DirEntry <$> (fields .: "type") <*> (fields .: "name") <*> (fields .: "path") <*> (fields .: "mtime"))

instance ToJSON DirEntry where toJSON value = Object (KM.fromList (concat [[("type", toJSON (dirEntryType value))], [("name", toJSON (dirEntryName value))], [("path", toJSON (dirEntryPath value))], [("mtime", toJSON (dirEntryMtime value))]]))

data DirEntryType = DirEntryTypeDir deriving (Eq, Show)

instance FromJSON DirEntryType where parseJSON = checked "DirEntryType" $ \value -> if value == String "dir" then pure DirEntryTypeDir else fail "unknown enumeration member"

instance ToJSON DirEntryType where toJSON DirEntryTypeDir = String "dir"

dirEntryTypeText :: DirEntryType -> Text
dirEntryTypeText DirEntryTypeDir = "dir"
