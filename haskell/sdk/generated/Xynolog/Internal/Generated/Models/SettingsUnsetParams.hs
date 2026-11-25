-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingsUnsetParams (SettingsUnsetParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion

data SettingsUnsetParams = SettingsUnsetParams
  { settingsUnsetParamsApiVersion :: ApiVersion,
    settingsUnsetParamsName :: Text,
    settingsUnsetParamsDefault :: Maybe Bool,
    settingsUnsetParamsRoot :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON SettingsUnsetParams where parseJSON = checked "SettingsUnsetParams" $ withObject "SettingsUnsetParams" (\fields -> SettingsUnsetParams <$> (fields .: "apiVersion") <*> (fields .: "name") <*> optional fields "default" <*> optional fields "root")

instance ToJSON SettingsUnsetParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (settingsUnsetParamsApiVersion value))], [("name", toJSON (settingsUnsetParamsName value))], optionalPair "default" (settingsUnsetParamsDefault value), optionalPair "root" (settingsUnsetParamsRoot value)]))
