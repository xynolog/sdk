-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ControlMethods (ControlMethods (..), ControlMethodsMethodsItem (..), ControlMethodsNotificationsItem (..), ControlMethodsNotificationsItemFrom (..), controlMethodsNotificationsItemFromText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ControlMethods = ControlMethods
  { controlMethodsU24_comment :: Text,
    controlMethodsApiVersion :: Text,
    controlMethodsErrorData :: Text,
    controlMethodsMethods :: [ControlMethodsMethodsItem],
    controlMethodsNotifications :: [ControlMethodsNotificationsItem]
  }
  deriving (Eq, Show)

instance FromJSON ControlMethods where parseJSON = checked "ControlMethods" $ withObject "ControlMethods" (\fields -> ControlMethods <$> (fields .: "$comment") <*> (fields .: "apiVersion") <*> (fields .: "errorData") <*> (fields .: "methods") <*> (fields .: "notifications"))

instance ToJSON ControlMethods where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (controlMethodsU24_comment value))], [("apiVersion", toJSON (controlMethodsApiVersion value))], [("errorData", toJSON (controlMethodsErrorData value))], [("methods", toJSON (controlMethodsMethods value))], [("notifications", toJSON (controlMethodsNotifications value))]]))

data ControlMethodsMethodsItem = ControlMethodsMethodsItem
  { controlMethodsMethodsItemDocs :: Text,
    controlMethodsMethodsItemExclusive :: Bool,
    controlMethodsMethodsItemName :: Text,
    controlMethodsMethodsItemParams :: Text,
    controlMethodsMethodsItemResult :: Text,
    controlMethodsMethodsItemSends :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON ControlMethodsMethodsItem where parseJSON = checked "ControlMethodsMethodsItem" $ withObject "ControlMethodsMethodsItem" (\fields -> ControlMethodsMethodsItem <$> (fields .: "docs") <*> (fields .: "exclusive") <*> (fields .: "name") <*> (fields .: "params") <*> (fields .: "result") <*> (fields .: "sends"))

instance ToJSON ControlMethodsMethodsItem where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (controlMethodsMethodsItemDocs value))], [("exclusive", toJSON (controlMethodsMethodsItemExclusive value))], [("name", toJSON (controlMethodsMethodsItemName value))], [("params", toJSON (controlMethodsMethodsItemParams value))], [("result", toJSON (controlMethodsMethodsItemResult value))], [("sends", toJSON (controlMethodsMethodsItemSends value))]]))

data ControlMethodsNotificationsItem = ControlMethodsNotificationsItem
  { controlMethodsNotificationsItemDocs :: Text,
    controlMethodsNotificationsItemFrom :: ControlMethodsNotificationsItemFrom,
    controlMethodsNotificationsItemName :: Text,
    controlMethodsNotificationsItemParams :: Text
  }
  deriving (Eq, Show)

instance FromJSON ControlMethodsNotificationsItem where parseJSON = checked "ControlMethodsNotificationsItem" $ withObject "ControlMethodsNotificationsItem" (\fields -> ControlMethodsNotificationsItem <$> (fields .: "docs") <*> (fields .: "from") <*> (fields .: "name") <*> (fields .: "params"))

instance ToJSON ControlMethodsNotificationsItem where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (controlMethodsNotificationsItemDocs value))], [("from", toJSON (controlMethodsNotificationsItemFrom value))], [("name", toJSON (controlMethodsNotificationsItemName value))], [("params", toJSON (controlMethodsNotificationsItemParams value))]]))

data ControlMethodsNotificationsItemFrom = ControlMethodsNotificationsItemFromClient | ControlMethodsNotificationsItemFromLauncher deriving (Eq, Show)

instance FromJSON ControlMethodsNotificationsItemFrom where parseJSON = checked "ControlMethodsNotificationsItemFrom" $ \value -> if value == String "client" then pure ControlMethodsNotificationsItemFromClient else if value == String "launcher" then pure ControlMethodsNotificationsItemFromLauncher else fail "unknown enumeration member"

instance ToJSON ControlMethodsNotificationsItemFrom where
  toJSON ControlMethodsNotificationsItemFromClient = String "client"
  toJSON ControlMethodsNotificationsItemFromLauncher = String "launcher"

controlMethodsNotificationsItemFromText :: ControlMethodsNotificationsItemFrom -> Text
controlMethodsNotificationsItemFromText ControlMethodsNotificationsItemFromClient = "client"
controlMethodsNotificationsItemFromText ControlMethodsNotificationsItemFromLauncher = "launcher"
