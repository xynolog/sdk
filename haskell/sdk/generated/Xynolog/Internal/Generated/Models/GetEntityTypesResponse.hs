-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GetEntityTypesResponse (GetEntityTypesResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data GetEntityTypesResponse = GetEntityTypesResponse
  { getEntityTypesResponseEntityTypes :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON GetEntityTypesResponse where parseJSON = checked "GetEntityTypesResponse" $ withObject "GetEntityTypesResponse" (\fields -> GetEntityTypesResponse <$> (fields .: "entityTypes"))

instance ToJSON GetEntityTypesResponse where toJSON value = Object (KM.fromList (concat [[("entityTypes", toJSON (getEntityTypesResponseEntityTypes value))]]))
