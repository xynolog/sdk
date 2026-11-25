-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseDirectoryResult (BrowseDirectoryResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.BrowseDirectoryResultResponse

data BrowseDirectoryResult = BrowseDirectoryResult
  { browseDirectoryResultResponse :: BrowseDirectoryResultResponse
  }
  deriving (Eq, Show)

instance FromJSON BrowseDirectoryResult where parseJSON = checked "BrowseDirectoryResult" $ withObject "BrowseDirectoryResult" (\fields -> BrowseDirectoryResult <$> (fields .: "response"))

instance ToJSON BrowseDirectoryResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (browseDirectoryResultResponse value))]]))
