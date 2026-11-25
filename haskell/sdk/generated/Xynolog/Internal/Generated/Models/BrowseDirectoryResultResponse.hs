-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseDirectoryResultResponse (BrowseDirectoryResultResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DirectoryEntry

data BrowseDirectoryResultResponse = BrowseDirectoryResultResponse
  { browseDirectoryResultResponsePath :: Text,
    browseDirectoryResultResponseEntries :: [DirectoryEntry]
  }
  deriving (Eq, Show)

instance FromJSON BrowseDirectoryResultResponse where parseJSON = checked "BrowseDirectoryResultResponse" $ withObject "BrowseDirectoryResultResponse" (\fields -> BrowseDirectoryResultResponse <$> (fields .: "path") <*> (fields .: "entries"))

instance ToJSON BrowseDirectoryResultResponse where toJSON value = Object (KM.fromList (concat [[("path", toJSON (browseDirectoryResultResponsePath value))], [("entries", toJSON (browseDirectoryResultResponseEntries value))]]))
