-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Setting (Setting (..), SettingAppliesTo (..), settingAppliesToText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.SettingLine

data Setting = Setting
  { settingAppliesTo :: SettingAppliesTo,
    settingChangedBy :: Maybe Text,
    settingDefault :: Bool,
    settingName :: Text,
    settingSettable :: Bool,
    settingValues :: [SettingLine]
  }
  deriving (Eq, Show)

instance FromJSON Setting where parseJSON = checked "Setting" $ withObject "Setting" (\fields -> Setting <$> (fields .: "appliesTo") <*> optional fields "changedBy" <*> (fields .: "default") <*> (fields .: "name") <*> (fields .: "settable") <*> (fields .: "values"))

instance ToJSON Setting where toJSON value = Object (KM.fromList (concat [[("appliesTo", toJSON (settingAppliesTo value))], optionalPair "changedBy" (settingChangedBy value), [("default", toJSON (settingDefault value))], [("name", toJSON (settingName value))], [("settable", toJSON (settingSettable value))], [("values", toJSON (settingValues value))]]))

data SettingAppliesTo = SettingAppliesToMachine | SettingAppliesToKnowledgeU2d_base deriving (Eq, Show)

instance FromJSON SettingAppliesTo where parseJSON = checked "SettingAppliesTo" $ \value -> if value == String "machine" then pure SettingAppliesToMachine else if value == String "knowledge-base" then pure SettingAppliesToKnowledgeU2d_base else fail "unknown enumeration member"

instance ToJSON SettingAppliesTo where
  toJSON SettingAppliesToMachine = String "machine"
  toJSON SettingAppliesToKnowledgeU2d_base = String "knowledge-base"

settingAppliesToText :: SettingAppliesTo -> Text
settingAppliesToText SettingAppliesToMachine = "machine"
settingAppliesToText SettingAppliesToKnowledgeU2d_base = "knowledge-base"
