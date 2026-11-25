-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GetTagSchemasResponse (GetTagSchemasResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.TagSchema

data GetTagSchemasResponse = GetTagSchemasResponse
  { getTagSchemasResponseTagSchemas :: [TagSchema]
  }
  deriving (Eq, Show)

instance FromJSON GetTagSchemasResponse where parseJSON = checked "GetTagSchemasResponse" $ withObject "GetTagSchemasResponse" (\fields -> GetTagSchemasResponse <$> (fields .: "tagSchemas"))

instance ToJSON GetTagSchemasResponse where toJSON value = Object (KM.fromList (concat [[("tagSchemas", toJSON (getTagSchemasResponseTagSchemas value))]]))
