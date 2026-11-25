-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingsGetParams (SettingsGetParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion

data SettingsGetParams = SettingsGetParams
  { settingsGetParamsApiVersion :: ApiVersion,
    settingsGetParamsName :: Text,
    settingsGetParamsDefault :: Maybe Bool,
    settingsGetParamsRoot :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON SettingsGetParams where parseJSON = checked "SettingsGetParams" $ withObject "SettingsGetParams" (\fields -> SettingsGetParams <$> (fields .: "apiVersion") <*> (fields .: "name") <*> optional fields "default" <*> optional fields "root")

instance ToJSON SettingsGetParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (settingsGetParamsApiVersion value))], [("name", toJSON (settingsGetParamsName value))], optionalPair "default" (settingsGetParamsDefault value), optionalPair "root" (settingsGetParamsRoot value)]))
