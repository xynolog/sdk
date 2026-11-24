-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingsSetParams (SettingsSetParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion

data SettingsSetParams = SettingsSetParams
  { settingsSetParamsApiVersion :: ApiVersion,
    settingsSetParamsDefault :: Maybe Bool,
    settingsSetParamsName :: Text,
    settingsSetParamsRoot :: Maybe Text,
    settingsSetParamsValue :: Text
  }
  deriving (Eq, Show)

instance FromJSON SettingsSetParams where parseJSON = checked "SettingsSetParams" $ withObject "SettingsSetParams" (\fields -> SettingsSetParams <$> (fields .: "apiVersion") <*> optional fields "default" <*> (fields .: "name") <*> optional fields "root" <*> (fields .: "value"))

instance ToJSON SettingsSetParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (settingsSetParamsApiVersion value))], optionalPair "default" (settingsSetParamsDefault value), [("name", toJSON (settingsSetParamsName value))], optionalPair "root" (settingsSetParamsRoot value), [("value", toJSON (settingsSetParamsValue value))]]))
