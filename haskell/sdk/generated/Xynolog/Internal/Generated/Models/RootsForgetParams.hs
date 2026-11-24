-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RootsForgetParams (RootsForgetParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion

data RootsForgetParams = RootsForgetParams
  { rootsForgetParamsApiVersion :: ApiVersion,
    rootsForgetParamsRoot :: Text
  }
  deriving (Eq, Show)

instance FromJSON RootsForgetParams where parseJSON = checked "RootsForgetParams" $ withObject "RootsForgetParams" (\fields -> RootsForgetParams <$> (fields .: "apiVersion") <*> (fields .: "root"))

instance ToJSON RootsForgetParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (rootsForgetParamsApiVersion value))], [("root", toJSON (rootsForgetParamsRoot value))]]))
