-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingsLocaleChangedEvent (SettingsLocaleChangedEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SettingsLocaleChangedEvent = SettingsLocaleChangedEvent
  { settingsLocaleChangedEventLocale :: Text
  }
  deriving (Eq, Show)

instance FromJSON SettingsLocaleChangedEvent where parseJSON = checked "SettingsLocaleChangedEvent" $ withObject "SettingsLocaleChangedEvent" (\fields -> SettingsLocaleChangedEvent <$> (fields .: "locale"))

instance ToJSON SettingsLocaleChangedEvent where toJSON value = Object (KM.fromList (concat [[("locale", toJSON (settingsLocaleChangedEventLocale value))]]))
