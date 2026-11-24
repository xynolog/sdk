-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingsListParams (SettingsListParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion

data SettingsListParams = SettingsListParams
  { settingsListParamsApiVersion :: ApiVersion,
    settingsListParamsRoot :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON SettingsListParams where parseJSON = checked "SettingsListParams" $ withObject "SettingsListParams" (\fields -> SettingsListParams <$> (fields .: "apiVersion") <*> optional fields "root")

instance ToJSON SettingsListParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (settingsListParamsApiVersion value))], optionalPair "root" (settingsListParamsRoot value)]))
