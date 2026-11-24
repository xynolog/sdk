-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AboutParams (AboutParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion

data AboutParams = AboutParams
  { aboutParamsApiVersion :: ApiVersion
  }
  deriving (Eq, Show)

instance FromJSON AboutParams where parseJSON = checked "AboutParams" $ withObject "AboutParams" (\fields -> AboutParams <$> (fields .: "apiVersion"))

instance ToJSON AboutParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (aboutParamsApiVersion value))]]))
