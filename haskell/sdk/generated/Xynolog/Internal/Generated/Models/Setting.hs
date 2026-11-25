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
  { settingName :: Text,
    settingDefault :: Bool,
    settingAppliesTo :: SettingAppliesTo,
    settingValues :: [SettingLine],
    settingSettable :: Bool,
    settingChangedBy :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON Setting where parseJSON = checked "Setting" $ withObject "Setting" (\fields -> Setting <$> (fields .: "name") <*> (fields .: "default") <*> (fields .: "appliesTo") <*> (fields .: "values") <*> (fields .: "settable") <*> optional fields "changedBy")

instance ToJSON Setting where toJSON value = Object (KM.fromList (concat [[("name", toJSON (settingName value))], [("default", toJSON (settingDefault value))], [("appliesTo", toJSON (settingAppliesTo value))], [("values", toJSON (settingValues value))], [("settable", toJSON (settingSettable value))], optionalPair "changedBy" (settingChangedBy value)]))

data SettingAppliesTo = SettingAppliesToMachine | SettingAppliesToKnowledgeBase deriving (Eq, Show)

instance FromJSON SettingAppliesTo where parseJSON = checked "SettingAppliesTo" $ \value -> if value == String "machine" then pure SettingAppliesToMachine else if value == String "knowledge-base" then pure SettingAppliesToKnowledgeBase else fail "unknown enumeration member"

instance ToJSON SettingAppliesTo where
  toJSON SettingAppliesToMachine = String "machine"
  toJSON SettingAppliesToKnowledgeBase = String "knowledge-base"

settingAppliesToText :: SettingAppliesTo -> Text
settingAppliesToText SettingAppliesToMachine = "machine"
settingAppliesToText SettingAppliesToKnowledgeBase = "knowledge-base"
