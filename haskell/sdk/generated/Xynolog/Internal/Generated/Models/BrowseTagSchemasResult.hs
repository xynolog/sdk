-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseTagSchemasResult (BrowseTagSchemasResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GetTagSchemasResponse

data BrowseTagSchemasResult = BrowseTagSchemasResult
  { browseTagSchemasResultResponse :: GetTagSchemasResponse
  }
  deriving (Eq, Show)

instance FromJSON BrowseTagSchemasResult where parseJSON = checked "BrowseTagSchemasResult" $ withObject "BrowseTagSchemasResult" (\fields -> BrowseTagSchemasResult <$> (fields .: "response"))

instance ToJSON BrowseTagSchemasResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (browseTagSchemasResultResponse value))]]))
