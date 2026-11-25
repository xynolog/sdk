-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingLine (SettingLine (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SettingLine = SettingLine
  { settingLineValue :: Text,
    settingLineSource :: Text
  }
  deriving (Eq, Show)

instance FromJSON SettingLine where parseJSON = checked "SettingLine" $ withObject "SettingLine" (\fields -> SettingLine <$> (fields .: "value") <*> (fields .: "source"))

instance ToJSON SettingLine where toJSON value = Object (KM.fromList (concat [[("value", toJSON (settingLineValue value))], [("source", toJSON (settingLineSource value))]]))
