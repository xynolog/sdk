-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseDirectoryFailed (BrowseDirectoryFailed (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.CommandError

data BrowseDirectoryFailed = BrowseDirectoryFailed
  { browseDirectoryFailedCode :: Maybe CommandErrorCode,
    browseDirectoryFailedDetails :: Maybe Text,
    browseDirectoryFailedMessage :: Text,
    browseDirectoryFailedPath :: Text
  }
  deriving (Eq, Show)

instance FromJSON BrowseDirectoryFailed where parseJSON = checked "BrowseDirectoryFailed" $ withObject "BrowseDirectoryFailed" (\fields -> BrowseDirectoryFailed <$> optional fields "code" <*> optional fields "details" <*> (fields .: "message") <*> (fields .: "path"))

instance ToJSON BrowseDirectoryFailed where toJSON value = Object (KM.fromList (concat [optionalPair "code" (browseDirectoryFailedCode value), optionalPair "details" (browseDirectoryFailedDetails value), [("message", toJSON (browseDirectoryFailedMessage value))], [("path", toJSON (browseDirectoryFailedPath value))]]))
