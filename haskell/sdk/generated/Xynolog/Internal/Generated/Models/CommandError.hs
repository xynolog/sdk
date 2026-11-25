-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.CommandError (CommandError (..), CommandErrorCode (..), commandErrorCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data CommandError = CommandError
  { commandErrorCode :: Maybe CommandErrorCode,
    commandErrorDetails :: Maybe Text,
    commandErrorMessage :: Text,
    commandErrorAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON CommandError where parseJSON = checked "CommandError" $ withObject "CommandError" (\fields -> CommandError <$> optional fields "code" <*> optional fields "details" <*> (fields .: "message") <*> traverse parseJSON (withoutFields ["code", "details", "message"] fields))

instance ToJSON CommandError where toJSON value = Object (KM.fromList (concat [optionalPair "code" (commandErrorCode value), optionalPair "details" (commandErrorDetails value), [("message", toJSON (commandErrorMessage value))]]) <> fmap toJSON (withoutFields ["code", "details", "message"] (commandErrorAdditionalProperties value)))

data CommandErrorCode = CommandErrorCodePeerUnavailable | CommandErrorCodeNotFound | CommandErrorCodeUnauthorized | CommandErrorCodeNonePending deriving (Eq, Show)

instance FromJSON CommandErrorCode where parseJSON = checked "CommandErrorCode" $ \value -> if value == String "peer-unavailable" then pure CommandErrorCodePeerUnavailable else if value == String "not-found" then pure CommandErrorCodeNotFound else if value == String "unauthorized" then pure CommandErrorCodeUnauthorized else if value == String "none-pending" then pure CommandErrorCodeNonePending else fail "unknown enumeration member"

instance ToJSON CommandErrorCode where
  toJSON CommandErrorCodePeerUnavailable = String "peer-unavailable"
  toJSON CommandErrorCodeNotFound = String "not-found"
  toJSON CommandErrorCodeUnauthorized = String "unauthorized"
  toJSON CommandErrorCodeNonePending = String "none-pending"

commandErrorCodeText :: CommandErrorCode -> Text
commandErrorCodeText CommandErrorCodePeerUnavailable = "peer-unavailable"
commandErrorCodeText CommandErrorCodeNotFound = "not-found"
commandErrorCodeText CommandErrorCodeUnauthorized = "unauthorized"
commandErrorCodeText CommandErrorCodeNonePending = "none-pending"
