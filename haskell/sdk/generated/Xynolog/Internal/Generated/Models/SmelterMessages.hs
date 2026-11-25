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
  { smelterMessagesComment :: Text,
    smelterMessagesRefusals :: [SmelterMessagesRefusalsItem],
    smelterMessagesLogged :: [SmelterMessagesLoggedItem]
  }
  deriving (Eq, Show)

instance FromJSON SmelterMessages where parseJSON = checked "SmelterMessages" $ withObject "SmelterMessages" (\fields -> SmelterMessages <$> (fields .: "$comment") <*> (fields .: "refusals") <*> (fields .: "logged"))

instance ToJSON SmelterMessages where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (smelterMessagesComment value))], [("refusals", toJSON (smelterMessagesRefusals value))], [("logged", toJSON (smelterMessagesLogged value))]]))

data SmelterMessagesLoggedItem = SmelterMessagesLoggedItem
  { smelterMessagesLoggedItemName :: Text,
    smelterMessagesLoggedItemLevel :: LogLevel,
    smelterMessagesLoggedItemSituation :: Text,
    smelterMessagesLoggedItemMessage :: Text,
    smelterMessagesLoggedItemFields :: SmelterMessagesLoggedItemFields,
    smelterMessagesLoggedItemCarries :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON SmelterMessagesLoggedItem where parseJSON = checked "SmelterMessagesLoggedItem" $ withObject "SmelterMessagesLoggedItem" (\fields -> SmelterMessagesLoggedItem <$> (fields .: "name") <*> (fields .: "level") <*> (fields .: "situation") <*> (fields .: "message") <*> (fields .: "fields") <*> (fields .: "carries"))

instance ToJSON SmelterMessagesLoggedItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (smelterMessagesLoggedItemName value))], [("level", toJSON (smelterMessagesLoggedItemLevel value))], [("situation", toJSON (smelterMessagesLoggedItemSituation value))], [("message", toJSON (smelterMessagesLoggedItemMessage value))], [("fields", toJSON (smelterMessagesLoggedItemFields value))], [("carries", toJSON (smelterMessagesLoggedItemCarries value))]]))

data SmelterMessagesLoggedItemFields = SmelterMessagesLoggedItemFields
  { smelterMessagesLoggedItemFieldsAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON SmelterMessagesLoggedItemFields where parseJSON = checked "SmelterMessagesLoggedItemFields" $ withObject "SmelterMessagesLoggedItemFields" (\fields -> SmelterMessagesLoggedItemFields <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON SmelterMessagesLoggedItemFields where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (smelterMessagesLoggedItemFieldsAdditionalProperties value)))

data SmelterMessagesRefusalsItem = SmelterMessagesRefusalsItem
  { smelterMessagesRefusalsItemName :: Text,
    smelterMessagesRefusalsItemOperation :: Text,
    smelterMessagesRefusalsItemSituation :: Text,
    smelterMessagesRefusalsItemMessage :: Text
  }
  deriving (Eq, Show)

instance FromJSON SmelterMessagesRefusalsItem where parseJSON = checked "SmelterMessagesRefusalsItem" $ withObject "SmelterMessagesRefusalsItem" (\fields -> SmelterMessagesRefusalsItem <$> (fields .: "name") <*> (fields .: "operation") <*> (fields .: "situation") <*> (fields .: "message"))

instance ToJSON SmelterMessagesRefusalsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (smelterMessagesRefusalsItemName value))], [("operation", toJSON (smelterMessagesRefusalsItemOperation value))], [("situation", toJSON (smelterMessagesRefusalsItemSituation value))], [("message", toJSON (smelterMessagesRefusalsItemMessage value))]]))
