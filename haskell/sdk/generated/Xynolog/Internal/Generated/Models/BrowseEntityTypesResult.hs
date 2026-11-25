-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseEntityTypesResult (BrowseEntityTypesResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GetEntityTypesResponse

data BrowseEntityTypesResult = BrowseEntityTypesResult
  { browseEntityTypesResultResponse :: GetEntityTypesResponse
  }
  deriving (Eq, Show)

instance FromJSON BrowseEntityTypesResult where parseJSON = checked "BrowseEntityTypesResult" $ withObject "BrowseEntityTypesResult" (\fields -> BrowseEntityTypesResult <$> (fields .: "response"))

instance ToJSON BrowseEntityTypesResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (browseEntityTypesResultResponse value))]]))
