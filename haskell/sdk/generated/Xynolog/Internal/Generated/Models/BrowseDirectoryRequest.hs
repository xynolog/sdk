-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseDirectoryRequest (BrowseDirectoryRequest (..), BrowseDirectoryRequestSort (..), browseDirectoryRequestSortText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data BrowseDirectoryRequest = BrowseDirectoryRequest
  { browseDirectoryRequestPath :: Text,
    browseDirectoryRequestSort :: Maybe BrowseDirectoryRequestSort,
    browseDirectoryRequestAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON BrowseDirectoryRequest where parseJSON = checked "BrowseDirectoryRequest" $ withObject "BrowseDirectoryRequest" (\fields -> BrowseDirectoryRequest <$> (fields .: "path") <*> optional fields "sort" <*> traverse parseJSON (withoutFields ["path", "sort"] fields))

instance ToJSON BrowseDirectoryRequest where toJSON value = Object (KM.fromList (concat [[("path", toJSON (browseDirectoryRequestPath value))], optionalPair "sort" (browseDirectoryRequestSort value)]) <> fmap toJSON (withoutFields ["path", "sort"] (browseDirectoryRequestAdditionalProperties value)))

data BrowseDirectoryRequestSort = BrowseDirectoryRequestSortName | BrowseDirectoryRequestSortMtime | BrowseDirectoryRequestSortAnnotationCount deriving (Eq, Show)

instance FromJSON BrowseDirectoryRequestSort where parseJSON = checked "BrowseDirectoryRequestSort" $ \value -> if value == String "name" then pure BrowseDirectoryRequestSortName else if value == String "mtime" then pure BrowseDirectoryRequestSortMtime else if value == String "annotationCount" then pure BrowseDirectoryRequestSortAnnotationCount else fail "unknown enumeration member"

instance ToJSON BrowseDirectoryRequestSort where
  toJSON BrowseDirectoryRequestSortName = String "name"
  toJSON BrowseDirectoryRequestSortMtime = String "mtime"
  toJSON BrowseDirectoryRequestSortAnnotationCount = String "annotationCount"

browseDirectoryRequestSortText :: BrowseDirectoryRequestSort -> Text
browseDirectoryRequestSortText BrowseDirectoryRequestSortName = "name"
browseDirectoryRequestSortText BrowseDirectoryRequestSortMtime = "mtime"
browseDirectoryRequestSortText BrowseDirectoryRequestSortAnnotationCount = "annotationCount"
