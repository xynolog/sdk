-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RootsListParams (RootsListParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion

data RootsListParams = RootsListParams
  { rootsListParamsApiVersion :: ApiVersion
  }
  deriving (Eq, Show)

instance FromJSON RootsListParams where parseJSON = checked "RootsListParams" $ withObject "RootsListParams" (\fields -> RootsListParams <$> (fields .: "apiVersion"))

instance ToJSON RootsListParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (rootsListParamsApiVersion value))]]))
