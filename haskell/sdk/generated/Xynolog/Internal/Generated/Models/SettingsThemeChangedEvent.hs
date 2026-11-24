-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingsThemeChangedEvent (SettingsThemeChangedEvent (..), SettingsThemeChangedEventTheme (..), settingsThemeChangedEventThemeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SettingsThemeChangedEvent = SettingsThemeChangedEvent
  { settingsThemeChangedEventTheme :: SettingsThemeChangedEventTheme,
    settingsThemeChangedEventAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON SettingsThemeChangedEvent where parseJSON = checked "SettingsThemeChangedEvent" $ withObject "SettingsThemeChangedEvent" (\fields -> SettingsThemeChangedEvent <$> (fields .: "theme") <*> traverse parseJSON (withoutFields ["theme"] fields))

instance ToJSON SettingsThemeChangedEvent where toJSON value = Object (KM.fromList (concat [[("theme", toJSON (settingsThemeChangedEventTheme value))]]) <> fmap toJSON (withoutFields ["theme"] (settingsThemeChangedEventAdditionalProperties value)))

data SettingsThemeChangedEventTheme = SettingsThemeChangedEventThemeLight | SettingsThemeChangedEventThemeDark | SettingsThemeChangedEventThemeSystem deriving (Eq, Show)

instance FromJSON SettingsThemeChangedEventTheme where parseJSON = checked "SettingsThemeChangedEventTheme" $ \value -> if value == String "light" then pure SettingsThemeChangedEventThemeLight else if value == String "dark" then pure SettingsThemeChangedEventThemeDark else if value == String "system" then pure SettingsThemeChangedEventThemeSystem else fail "unknown enumeration member"

instance ToJSON SettingsThemeChangedEventTheme where
  toJSON SettingsThemeChangedEventThemeLight = String "light"
  toJSON SettingsThemeChangedEventThemeDark = String "dark"
  toJSON SettingsThemeChangedEventThemeSystem = String "system"

settingsThemeChangedEventThemeText :: SettingsThemeChangedEventTheme -> Text
settingsThemeChangedEventThemeText SettingsThemeChangedEventThemeLight = "light"
settingsThemeChangedEventThemeText SettingsThemeChangedEventThemeDark = "dark"
settingsThemeChangedEventThemeText SettingsThemeChangedEventThemeSystem = "system"
