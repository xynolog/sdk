-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SmelterMessages (SmelterMessages (..), SmelterMessagesLoggedItem (..), SmelterMessagesLoggedItemFields (..), SmelterMessagesRefusalsItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.LogLevel

data SmelterMessages = SmelterMessages
  { smelterMessagesLogged :: [SmelterMessagesLoggedItem],
    smelterMessagesRefusals :: [SmelterMessagesRefusalsItem]
  }
  deriving (Eq, Show)

instance FromJSON SmelterMessages where parseJSON = checked "SmelterMessages" $ withObject "SmelterMessages" (\fields -> SmelterMessages <$> (fields .: "logged") <*> (fields .: "refusals"))

instance ToJSON SmelterMessages where toJSON value = Object (KM.fromList (concat [[("logged", toJSON (smelterMessagesLogged value))], [("refusals", toJSON (smelterMessagesRefusals value))]]))

data SmelterMessagesLoggedItem = SmelterMessagesLoggedItem
  { smelterMessagesLoggedItemCarries :: [Text],
    smelterMessagesLoggedItemFields :: SmelterMessagesLoggedItemFields,
    smelterMessagesLoggedItemLevel :: LogLevel,
    smelterMessagesLoggedItemMessage :: Text,
    smelterMessagesLoggedItemName :: Text,
    smelterMessagesLoggedItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON SmelterMessagesLoggedItem where parseJSON = checked "SmelterMessagesLoggedItem" $ withObject "SmelterMessagesLoggedItem" (\fields -> SmelterMessagesLoggedItem <$> (fields .: "carries") <*> (fields .: "fields") <*> (fields .: "level") <*> (fields .: "message") <*> (fields .: "name") <*> (fields .: "situation"))

instance ToJSON SmelterMessagesLoggedItem where toJSON value = Object (KM.fromList (concat [[("carries", toJSON (smelterMessagesLoggedItemCarries value))], [("fields", toJSON (smelterMessagesLoggedItemFields value))], [("level", toJSON (smelterMessagesLoggedItemLevel value))], [("message", toJSON (smelterMessagesLoggedItemMessage value))], [("name", toJSON (smelterMessagesLoggedItemName value))], [("situation", toJSON (smelterMessagesLoggedItemSituation value))]]))

data SmelterMessagesLoggedItemFields = SmelterMessagesLoggedItemFields
  { smelterMessagesLoggedItemFieldsAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON SmelterMessagesLoggedItemFields where parseJSON = checked "SmelterMessagesLoggedItemFields" $ withObject "SmelterMessagesLoggedItemFields" (\fields -> SmelterMessagesLoggedItemFields <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON SmelterMessagesLoggedItemFields where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (smelterMessagesLoggedItemFieldsAdditionalProperties value)))

data SmelterMessagesRefusalsItem = SmelterMessagesRefusalsItem
  { smelterMessagesRefusalsItemMessage :: Text,
    smelterMessagesRefusalsItemName :: Text,
    smelterMessagesRefusalsItemOperation :: Text,
    smelterMessagesRefusalsItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON SmelterMessagesRefusalsItem where parseJSON = checked "SmelterMessagesRefusalsItem" $ withObject "SmelterMessagesRefusalsItem" (\fields -> SmelterMessagesRefusalsItem <$> (fields .: "message") <*> (fields .: "name") <*> (fields .: "operation") <*> (fields .: "situation"))

instance ToJSON SmelterMessagesRefusalsItem where toJSON value = Object (KM.fromList (concat [[("message", toJSON (smelterMessagesRefusalsItemMessage value))], [("name", toJSON (smelterMessagesRefusalsItemName value))], [("operation", toJSON (smelterMessagesRefusalsItemOperation value))], [("situation", toJSON (smelterMessagesRefusalsItemSituation value))]]))
