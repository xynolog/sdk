-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ControlCli (ControlCli (..), ControlCliCommands (..), ControlCliCommandsValue (..), ControlCliCommandsValueFlags (..), ControlCliCommandsValueFlagsValue (..), ControlCliCommandsValueFlagsValueCliOnly (..), ControlCliCommandsValueFlagsValueFields (..), ControlCliCommandsValueFlagsValueMethod (..), ControlCliCommandsValuePositionalsItem (..), ControlCliCommandsValuePositionalsItemCliOnly (..), ControlCliCommandsValuePositionalsItemFields (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ControlCli = ControlCli
  { controlCliComment :: Text,
    controlCliCommands :: ControlCliCommands
  }
  deriving (Eq, Show)

instance FromJSON ControlCli where parseJSON = checked "ControlCli" $ withObject "ControlCli" (\fields -> ControlCli <$> (fields .: "$comment") <*> (fields .: "commands"))

instance ToJSON ControlCli where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (controlCliComment value))], [("commands", toJSON (controlCliCommands value))]]))

data ControlCliCommands = ControlCliCommands
  { controlCliCommandsAdditionalProperties :: KM.KeyMap ControlCliCommandsValue
  }
  deriving (Eq, Show)

instance FromJSON ControlCliCommands where parseJSON = checked "ControlCliCommands" $ withObject "ControlCliCommands" (\fields -> ControlCliCommands <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ControlCliCommands where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (controlCliCommandsAdditionalProperties value)))

data ControlCliCommandsValue = ControlCliCommandsValue
  { controlCliCommandsValueParser :: Text,
    controlCliCommandsValueMethod :: Text,
    controlCliCommandsValuePositionals :: Maybe [ControlCliCommandsValuePositionalsItem],
    controlCliCommandsValueFlags :: ControlCliCommandsValueFlags
  }
  deriving (Eq, Show)

instance FromJSON ControlCliCommandsValue where parseJSON = checked "ControlCliCommandsValue" $ withObject "ControlCliCommandsValue" (\fields -> ControlCliCommandsValue <$> (fields .: "parser") <*> (fields .: "method") <*> optional fields "positionals" <*> (fields .: "flags"))

instance ToJSON ControlCliCommandsValue where toJSON value = Object (KM.fromList (concat [[("parser", toJSON (controlCliCommandsValueParser value))], [("method", toJSON (controlCliCommandsValueMethod value))], optionalPair "positionals" (controlCliCommandsValuePositionals value), [("flags", toJSON (controlCliCommandsValueFlags value))]]))

data ControlCliCommandsValueFlags = ControlCliCommandsValueFlags
  { controlCliCommandsValueFlagsAdditionalProperties :: KM.KeyMap ControlCliCommandsValueFlagsValue
  }
  deriving (Eq, Show)

instance FromJSON ControlCliCommandsValueFlags where parseJSON = checked "ControlCliCommandsValueFlags" $ withObject "ControlCliCommandsValueFlags" (\fields -> ControlCliCommandsValueFlags <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ControlCliCommandsValueFlags where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (controlCliCommandsValueFlagsAdditionalProperties value)))

data ControlCliCommandsValueFlagsValue = ControlCliCommandsValueFlagsValueFields ControlCliCommandsValueFlagsValueFields | ControlCliCommandsValueFlagsValueMethod ControlCliCommandsValueFlagsValueMethod | ControlCliCommandsValueFlagsValueCliOnly ControlCliCommandsValueFlagsValueCliOnly deriving (Eq, Show)

instance FromJSON ControlCliCommandsValueFlagsValue where parseJSON = checked "ControlCliCommandsValueFlagsValue" $ \value -> (ControlCliCommandsValueFlagsValueFields <$> parseJSON value) <|> (ControlCliCommandsValueFlagsValueMethod <$> parseJSON value) <|> (ControlCliCommandsValueFlagsValueCliOnly <$> parseJSON value)

instance ToJSON ControlCliCommandsValueFlagsValue where
  toJSON (ControlCliCommandsValueFlagsValueFields value) = toJSON value
  toJSON (ControlCliCommandsValueFlagsValueMethod value) = toJSON value
  toJSON (ControlCliCommandsValueFlagsValueCliOnly value) = toJSON value

data ControlCliCommandsValueFlagsValueCliOnly = MkControlCliCommandsValueFlagsValueCliOnly
  { controlCliCommandsValueFlagsValueCliOnlyCliOnly :: Text
  }
  deriving (Eq, Show)

instance FromJSON ControlCliCommandsValueFlagsValueCliOnly where parseJSON = checked "ControlCliCommandsValueFlagsValueCliOnly" $ withObject "ControlCliCommandsValueFlagsValueCliOnly" (\fields -> MkControlCliCommandsValueFlagsValueCliOnly <$> (fields .: "cliOnly"))

instance ToJSON ControlCliCommandsValueFlagsValueCliOnly where toJSON value = Object (KM.fromList (concat [[("cliOnly", toJSON (controlCliCommandsValueFlagsValueCliOnlyCliOnly value))]]))

data ControlCliCommandsValueFlagsValueFields = MkControlCliCommandsValueFlagsValueFields
  { controlCliCommandsValueFlagsValueFieldsFields :: [Text],
    controlCliCommandsValueFlagsValueFieldsNotes :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ControlCliCommandsValueFlagsValueFields where parseJSON = checked "ControlCliCommandsValueFlagsValueFields" $ withObject "ControlCliCommandsValueFlagsValueFields" (\fields -> MkControlCliCommandsValueFlagsValueFields <$> (fields .: "fields") <*> optional fields "notes")

instance ToJSON ControlCliCommandsValueFlagsValueFields where toJSON value = Object (KM.fromList (concat [[("fields", toJSON (controlCliCommandsValueFlagsValueFieldsFields value))], optionalPair "notes" (controlCliCommandsValueFlagsValueFieldsNotes value)]))

data ControlCliCommandsValueFlagsValueMethod = MkControlCliCommandsValueFlagsValueMethod
  { controlCliCommandsValueFlagsValueMethodMethod :: Text
  }
  deriving (Eq, Show)

instance FromJSON ControlCliCommandsValueFlagsValueMethod where parseJSON = checked "ControlCliCommandsValueFlagsValueMethod" $ withObject "ControlCliCommandsValueFlagsValueMethod" (\fields -> MkControlCliCommandsValueFlagsValueMethod <$> (fields .: "method"))

instance ToJSON ControlCliCommandsValueFlagsValueMethod where toJSON value = Object (KM.fromList (concat [[("method", toJSON (controlCliCommandsValueFlagsValueMethodMethod value))]]))

data ControlCliCommandsValuePositionalsItem = ControlCliCommandsValuePositionalsItemFields ControlCliCommandsValuePositionalsItemFields | ControlCliCommandsValuePositionalsItemCliOnly ControlCliCommandsValuePositionalsItemCliOnly deriving (Eq, Show)

instance FromJSON ControlCliCommandsValuePositionalsItem where parseJSON = checked "ControlCliCommandsValuePositionalsItem" $ \value -> (ControlCliCommandsValuePositionalsItemFields <$> parseJSON value) <|> (ControlCliCommandsValuePositionalsItemCliOnly <$> parseJSON value)

instance ToJSON ControlCliCommandsValuePositionalsItem where
  toJSON (ControlCliCommandsValuePositionalsItemFields value) = toJSON value
  toJSON (ControlCliCommandsValuePositionalsItemCliOnly value) = toJSON value

data ControlCliCommandsValuePositionalsItemCliOnly = MkControlCliCommandsValuePositionalsItemCliOnly
  { controlCliCommandsValuePositionalsItemCliOnlyName :: Text,
    controlCliCommandsValuePositionalsItemCliOnlyCliOnly :: Text
  }
  deriving (Eq, Show)

instance FromJSON ControlCliCommandsValuePositionalsItemCliOnly where parseJSON = checked "ControlCliCommandsValuePositionalsItemCliOnly" $ withObject "ControlCliCommandsValuePositionalsItemCliOnly" (\fields -> MkControlCliCommandsValuePositionalsItemCliOnly <$> (fields .: "name") <*> (fields .: "cliOnly"))

instance ToJSON ControlCliCommandsValuePositionalsItemCliOnly where toJSON value = Object (KM.fromList (concat [[("name", toJSON (controlCliCommandsValuePositionalsItemCliOnlyName value))], [("cliOnly", toJSON (controlCliCommandsValuePositionalsItemCliOnlyCliOnly value))]]))

data ControlCliCommandsValuePositionalsItemFields = MkControlCliCommandsValuePositionalsItemFields
  { controlCliCommandsValuePositionalsItemFieldsName :: Text,
    controlCliCommandsValuePositionalsItemFieldsFields :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON ControlCliCommandsValuePositionalsItemFields where parseJSON = checked "ControlCliCommandsValuePositionalsItemFields" $ withObject "ControlCliCommandsValuePositionalsItemFields" (\fields -> MkControlCliCommandsValuePositionalsItemFields <$> (fields .: "name") <*> (fields .: "fields"))

instance ToJSON ControlCliCommandsValuePositionalsItemFields where toJSON value = Object (KM.fromList (concat [[("name", toJSON (controlCliCommandsValuePositionalsItemFieldsName value))], [("fields", toJSON (controlCliCommandsValuePositionalsItemFieldsFields value))]]))
