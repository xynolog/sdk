-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingsPathResult (SettingsPathResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SettingsPathResult = SettingsPathResult
  { settingsPathResultPath :: Text
  }
  deriving (Eq, Show)

instance FromJSON SettingsPathResult where parseJSON = checked "SettingsPathResult" $ withObject "SettingsPathResult" (\fields -> SettingsPathResult <$> (fields .: "path"))

instance ToJSON SettingsPathResult where toJSON value = Object (KM.fromList (concat [[("path", toJSON (settingsPathResultPath value))]]))
