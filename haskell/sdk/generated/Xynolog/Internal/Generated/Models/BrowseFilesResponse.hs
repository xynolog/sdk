-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseFilesResponse (BrowseFilesResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DirectoryEntry

data BrowseFilesResponse = BrowseFilesResponse
  { browseFilesResponsePath :: Text,
    browseFilesResponseEntries :: [DirectoryEntry]
  }
  deriving (Eq, Show)

instance FromJSON BrowseFilesResponse where parseJSON = checked "BrowseFilesResponse" $ withObject "BrowseFilesResponse" (\fields -> BrowseFilesResponse <$> (fields .: "path") <*> (fields .: "entries"))

instance ToJSON BrowseFilesResponse where toJSON value = Object (KM.fromList (concat [[("path", toJSON (browseFilesResponsePath value))], [("entries", toJSON (browseFilesResponseEntries value))]]))
