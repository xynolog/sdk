-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseDirectoryFailed (BrowseDirectoryFailed (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ArchivistMessages

data BrowseDirectoryFailed = BrowseDirectoryFailed
  { browseDirectoryFailedCode :: Maybe CommandErrorCode,
    browseDirectoryFailedMessage :: Text,
    browseDirectoryFailedDetails :: Maybe Text,
    browseDirectoryFailedPath :: Text
  }
  deriving (Eq, Show)

instance FromJSON BrowseDirectoryFailed where parseJSON = checked "BrowseDirectoryFailed" $ withObject "BrowseDirectoryFailed" (\fields -> BrowseDirectoryFailed <$> optional fields "code" <*> (fields .: "message") <*> optional fields "details" <*> (fields .: "path"))

instance ToJSON BrowseDirectoryFailed where toJSON value = Object (KM.fromList (concat [optionalPair "code" (browseDirectoryFailedCode value), [("message", toJSON (browseDirectoryFailedMessage value))], optionalPair "details" (browseDirectoryFailedDetails value), [("path", toJSON (browseDirectoryFailedPath value))]]))
