-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingsListResult (SettingsListResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Setting

data SettingsListResult = SettingsListResult
  { settingsListResultRoot :: Maybe Text,
    settingsListResultUnresolved :: Maybe Text,
    settingsListResultSettings :: [Setting]
  }
  deriving (Eq, Show)

instance FromJSON SettingsListResult where parseJSON = checked "SettingsListResult" $ withObject "SettingsListResult" (\fields -> SettingsListResult <$> optional fields "root" <*> optional fields "unresolved" <*> (fields .: "settings"))

instance ToJSON SettingsListResult where toJSON value = Object (KM.fromList (concat [optionalPair "root" (settingsListResultRoot value), optionalPair "unresolved" (settingsListResultUnresolved value), [("settings", toJSON (settingsListResultSettings value))]]))
