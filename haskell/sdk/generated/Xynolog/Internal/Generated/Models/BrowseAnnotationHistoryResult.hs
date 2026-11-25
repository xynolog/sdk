-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseAnnotationHistoryResult (BrowseAnnotationHistoryResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GetAnnotationHistoryResponse

data BrowseAnnotationHistoryResult = BrowseAnnotationHistoryResult
  { browseAnnotationHistoryResultResponse :: GetAnnotationHistoryResponse
  }
  deriving (Eq, Show)

instance FromJSON BrowseAnnotationHistoryResult where parseJSON = checked "BrowseAnnotationHistoryResult" $ withObject "BrowseAnnotationHistoryResult" (\fields -> BrowseAnnotationHistoryResult <$> (fields .: "response"))

instance ToJSON BrowseAnnotationHistoryResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (browseAnnotationHistoryResultResponse value))]]))
