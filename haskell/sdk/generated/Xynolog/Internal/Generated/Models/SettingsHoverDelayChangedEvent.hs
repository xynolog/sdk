-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingsHoverDelayChangedEvent (SettingsHoverDelayChangedEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data SettingsHoverDelayChangedEvent = SettingsHoverDelayChangedEvent
  { settingsHoverDelayChangedEventHoverDelayMs :: Integer
  }
  deriving (Eq, Show)

instance FromJSON SettingsHoverDelayChangedEvent where parseJSON = checked "SettingsHoverDelayChangedEvent" $ withObject "SettingsHoverDelayChangedEvent" (\fields -> SettingsHoverDelayChangedEvent <$> (fields .: "hoverDelayMs"))

instance ToJSON SettingsHoverDelayChangedEvent where toJSON value = Object (KM.fromList (concat [[("hoverDelayMs", toJSON (settingsHoverDelayChangedEventHoverDelayMs value))]]))
