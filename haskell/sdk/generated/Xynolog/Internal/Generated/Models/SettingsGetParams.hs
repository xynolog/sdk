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
    settingsGetParamsDefault :: Maybe Bool,
    settingsGetParamsName :: Text,
    settingsGetParamsRoot :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON SettingsGetParams where parseJSON = checked "SettingsGetParams" $ withObject "SettingsGetParams" (\fields -> SettingsGetParams <$> (fields .: "apiVersion") <*> optional fields "default" <*> (fields .: "name") <*> optional fields "root")

instance ToJSON SettingsGetParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (settingsGetParamsApiVersion value))], optionalPair "default" (settingsGetParamsDefault value), [("name", toJSON (settingsGetParamsName value))], optionalPair "root" (settingsGetParamsRoot value)]))
