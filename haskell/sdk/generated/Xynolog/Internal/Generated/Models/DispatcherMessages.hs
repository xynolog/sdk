-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DispatcherMessages (DispatcherMessages (..), DispatcherMessagesErrorsItem (..), DispatcherMessagesRefusalsItem (..), DispatcherMessagesRefusalsItemCode (..), dispatcherMessagesRefusalsItemCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FailureClass

data DispatcherMessages = DispatcherMessages
  { dispatcherMessagesComment :: Text,
    dispatcherMessagesErrors :: [DispatcherMessagesErrorsItem],
    dispatcherMessagesRefusals :: [DispatcherMessagesRefusalsItem]
  }
  deriving (Eq, Show)

instance FromJSON DispatcherMessages where parseJSON = checked "DispatcherMessages" $ withObject "DispatcherMessages" (\fields -> DispatcherMessages <$> (fields .: "$comment") <*> (fields .: "errors") <*> (fields .: "refusals"))

instance ToJSON DispatcherMessages where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (dispatcherMessagesComment value))], [("errors", toJSON (dispatcherMessagesErrors value))], [("refusals", toJSON (dispatcherMessagesRefusals value))]]))

data DispatcherMessagesErrorsItem = DispatcherMessagesErrorsItem
  { dispatcherMessagesErrorsItemError :: Text,
    dispatcherMessagesErrorsItemFailureClass :: FailureClass,
    dispatcherMessagesErrorsItemName :: Text,
    dispatcherMessagesErrorsItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON DispatcherMessagesErrorsItem where parseJSON = checked "DispatcherMessagesErrorsItem" $ withObject "DispatcherMessagesErrorsItem" (\fields -> DispatcherMessagesErrorsItem <$> (fields .: "error") <*> (fields .: "failureClass") <*> (fields .: "name") <*> (fields .: "situation"))

instance ToJSON DispatcherMessagesErrorsItem where toJSON value = Object (KM.fromList (concat [[("error", toJSON (dispatcherMessagesErrorsItemError value))], [("failureClass", toJSON (dispatcherMessagesErrorsItemFailureClass value))], [("name", toJSON (dispatcherMessagesErrorsItemName value))], [("situation", toJSON (dispatcherMessagesErrorsItemSituation value))]]))

data DispatcherMessagesRefusalsItem = DispatcherMessagesRefusalsItem
  { dispatcherMessagesRefusalsItemCode :: Maybe DispatcherMessagesRefusalsItemCode,
    dispatcherMessagesRefusalsItemMessage :: Text,
    dispatcherMessagesRefusalsItemName :: Text,
    dispatcherMessagesRefusalsItemOperation :: Text,
    dispatcherMessagesRefusalsItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON DispatcherMessagesRefusalsItem where parseJSON = checked "DispatcherMessagesRefusalsItem" $ withObject "DispatcherMessagesRefusalsItem" (\fields -> DispatcherMessagesRefusalsItem <$> optional fields "code" <*> (fields .: "message") <*> (fields .: "name") <*> (fields .: "operation") <*> (fields .: "situation"))

instance ToJSON DispatcherMessagesRefusalsItem where toJSON value = Object (KM.fromList (concat [optionalPair "code" (dispatcherMessagesRefusalsItemCode value), [("message", toJSON (dispatcherMessagesRefusalsItemMessage value))], [("name", toJSON (dispatcherMessagesRefusalsItemName value))], [("operation", toJSON (dispatcherMessagesRefusalsItemOperation value))], [("situation", toJSON (dispatcherMessagesRefusalsItemSituation value))]]))

data DispatcherMessagesRefusalsItemCode = DispatcherMessagesRefusalsItemCodePeerUnavailable | DispatcherMessagesRefusalsItemCodeNotFound | DispatcherMessagesRefusalsItemCodeUnauthorized | DispatcherMessagesRefusalsItemCodeNonePending deriving (Eq, Show)

instance FromJSON DispatcherMessagesRefusalsItemCode where parseJSON = checked "DispatcherMessagesRefusalsItemCode" $ \value -> if value == String "peer-unavailable" then pure DispatcherMessagesRefusalsItemCodePeerUnavailable else if value == String "not-found" then pure DispatcherMessagesRefusalsItemCodeNotFound else if value == String "unauthorized" then pure DispatcherMessagesRefusalsItemCodeUnauthorized else if value == String "none-pending" then pure DispatcherMessagesRefusalsItemCodeNonePending else fail "unknown enumeration member"

instance ToJSON DispatcherMessagesRefusalsItemCode where
  toJSON DispatcherMessagesRefusalsItemCodePeerUnavailable = String "peer-unavailable"
  toJSON DispatcherMessagesRefusalsItemCodeNotFound = String "not-found"
  toJSON DispatcherMessagesRefusalsItemCodeUnauthorized = String "unauthorized"
  toJSON DispatcherMessagesRefusalsItemCodeNonePending = String "none-pending"

dispatcherMessagesRefusalsItemCodeText :: DispatcherMessagesRefusalsItemCode -> Text
dispatcherMessagesRefusalsItemCodeText DispatcherMessagesRefusalsItemCodePeerUnavailable = "peer-unavailable"
dispatcherMessagesRefusalsItemCodeText DispatcherMessagesRefusalsItemCodeNotFound = "not-found"
dispatcherMessagesRefusalsItemCodeText DispatcherMessagesRefusalsItemCodeUnauthorized = "unauthorized"
dispatcherMessagesRefusalsItemCodeText DispatcherMessagesRefusalsItemCodeNonePending = "none-pending"
