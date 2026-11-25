-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ControlMethods (ControlMethods (..), ControlMethodsMethodsItem (..), ControlMethodsNotificationsItem (..), ControlMethodsNotificationsItemFrom (..), controlMethodsNotificationsItemFromText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ControlMethods = ControlMethods
  { controlMethodsComment :: Text,
    controlMethodsApiVersion :: Text,
    controlMethodsErrorData :: Text,
    controlMethodsMethods :: [ControlMethodsMethodsItem],
    controlMethodsNotifications :: [ControlMethodsNotificationsItem]
  }
  deriving (Eq, Show)

instance FromJSON ControlMethods where parseJSON = checked "ControlMethods" $ withObject "ControlMethods" (\fields -> ControlMethods <$> (fields .: "$comment") <*> (fields .: "apiVersion") <*> (fields .: "errorData") <*> (fields .: "methods") <*> (fields .: "notifications"))

instance ToJSON ControlMethods where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (controlMethodsComment value))], [("apiVersion", toJSON (controlMethodsApiVersion value))], [("errorData", toJSON (controlMethodsErrorData value))], [("methods", toJSON (controlMethodsMethods value))], [("notifications", toJSON (controlMethodsNotifications value))]]))

data ControlMethodsMethodsItem = ControlMethodsMethodsItem
  { controlMethodsMethodsItemName :: Text,
    controlMethodsMethodsItemParams :: Text,
    controlMethodsMethodsItemResult :: Text,
    controlMethodsMethodsItemExclusive :: Bool,
    controlMethodsMethodsItemSends :: [Text],
    controlMethodsMethodsItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ControlMethodsMethodsItem where parseJSON = checked "ControlMethodsMethodsItem" $ withObject "ControlMethodsMethodsItem" (\fields -> ControlMethodsMethodsItem <$> (fields .: "name") <*> (fields .: "params") <*> (fields .: "result") <*> (fields .: "exclusive") <*> (fields .: "sends") <*> (fields .: "docs"))

instance ToJSON ControlMethodsMethodsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (controlMethodsMethodsItemName value))], [("params", toJSON (controlMethodsMethodsItemParams value))], [("result", toJSON (controlMethodsMethodsItemResult value))], [("exclusive", toJSON (controlMethodsMethodsItemExclusive value))], [("sends", toJSON (controlMethodsMethodsItemSends value))], [("docs", toJSON (controlMethodsMethodsItemDocs value))]]))

data ControlMethodsNotificationsItem = ControlMethodsNotificationsItem
  { controlMethodsNotificationsItemName :: Text,
    controlMethodsNotificationsItemFrom :: ControlMethodsNotificationsItemFrom,
    controlMethodsNotificationsItemParams :: Text,
    controlMethodsNotificationsItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ControlMethodsNotificationsItem where parseJSON = checked "ControlMethodsNotificationsItem" $ withObject "ControlMethodsNotificationsItem" (\fields -> ControlMethodsNotificationsItem <$> (fields .: "name") <*> (fields .: "from") <*> (fields .: "params") <*> (fields .: "docs"))

instance ToJSON ControlMethodsNotificationsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (controlMethodsNotificationsItemName value))], [("from", toJSON (controlMethodsNotificationsItemFrom value))], [("params", toJSON (controlMethodsNotificationsItemParams value))], [("docs", toJSON (controlMethodsNotificationsItemDocs value))]]))

data ControlMethodsNotificationsItemFrom = ControlMethodsNotificationsItemFromClient | ControlMethodsNotificationsItemFromLauncher deriving (Eq, Show)

instance FromJSON ControlMethodsNotificationsItemFrom where parseJSON = checked "ControlMethodsNotificationsItemFrom" $ \value -> if value == String "client" then pure ControlMethodsNotificationsItemFromClient else if value == String "launcher" then pure ControlMethodsNotificationsItemFromLauncher else fail "unknown enumeration member"

instance ToJSON ControlMethodsNotificationsItemFrom where
  toJSON ControlMethodsNotificationsItemFromClient = String "client"
  toJSON ControlMethodsNotificationsItemFromLauncher = String "launcher"

controlMethodsNotificationsItemFromText :: ControlMethodsNotificationsItemFrom -> Text
controlMethodsNotificationsItemFromText ControlMethodsNotificationsItemFromClient = "client"
controlMethodsNotificationsItemFromText ControlMethodsNotificationsItemFromLauncher = "launcher"
