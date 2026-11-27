-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.CommandError (CommandError (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ArchivistMessages

data CommandError = CommandError
  { commandErrorCode :: Maybe CommandErrorCode,
    commandErrorMessage :: Text,
    commandErrorDetails :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON CommandError where parseJSON = checked "CommandError" $ withObject "CommandError" (\fields -> CommandError <$> optional fields "code" <*> (fields .: "message") <*> optional fields "details")

instance ToJSON CommandError where toJSON value = Object (KM.fromList (concat [optionalPair "code" (commandErrorCode value), [("message", toJSON (commandErrorMessage value))], optionalPair "details" (commandErrorDetails value)]))
