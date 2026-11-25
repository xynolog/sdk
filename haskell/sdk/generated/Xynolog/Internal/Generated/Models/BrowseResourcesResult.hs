-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseResourcesResult (BrowseResourcesResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ListResourcesResponse

data BrowseResourcesResult = BrowseResourcesResult
  { browseResourcesResultResponse :: ListResourcesResponse
  }
  deriving (Eq, Show)

instance FromJSON BrowseResourcesResult where parseJSON = checked "BrowseResourcesResult" $ withObject "BrowseResourcesResult" (\fields -> BrowseResourcesResult <$> (fields .: "response"))

instance ToJSON BrowseResourcesResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (browseResourcesResultResponse value))]]))
