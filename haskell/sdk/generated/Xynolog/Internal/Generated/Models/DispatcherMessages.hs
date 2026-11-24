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
  { dispatcherMessagesErrors :: [DispatcherMessagesErrorsItem],
    dispatcherMessagesRefusals :: [DispatcherMessagesRefusalsItem]
  }
  deriving (Eq, Show)

instance FromJSON DispatcherMessages where parseJSON = checked "DispatcherMessages" $ withObject "DispatcherMessages" (\fields -> DispatcherMessages <$> (fields .: "errors") <*> (fields .: "refusals"))

instance ToJSON DispatcherMessages where toJSON value = Object (KM.fromList (concat [[("errors", toJSON (dispatcherMessagesErrors value))], [("refusals", toJSON (dispatcherMessagesRefusals value))]]))

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

data DispatcherMessagesRefusalsItemCode = DispatcherMessagesRefusalsItemCodePeerU2d_unavailable | DispatcherMessagesRefusalsItemCodeNotU2d_found | DispatcherMessagesRefusalsItemCodeUnauthorized | DispatcherMessagesRefusalsItemCodeNoneU2d_pending deriving (Eq, Show)

instance FromJSON DispatcherMessagesRefusalsItemCode where parseJSON = checked "DispatcherMessagesRefusalsItemCode" $ \value -> if value == String "peer-unavailable" then pure DispatcherMessagesRefusalsItemCodePeerU2d_unavailable else if value == String "not-found" then pure DispatcherMessagesRefusalsItemCodeNotU2d_found else if value == String "unauthorized" then pure DispatcherMessagesRefusalsItemCodeUnauthorized else if value == String "none-pending" then pure DispatcherMessagesRefusalsItemCodeNoneU2d_pending else fail "unknown enumeration member"

instance ToJSON DispatcherMessagesRefusalsItemCode where
  toJSON DispatcherMessagesRefusalsItemCodePeerU2d_unavailable = String "peer-unavailable"
  toJSON DispatcherMessagesRefusalsItemCodeNotU2d_found = String "not-found"
  toJSON DispatcherMessagesRefusalsItemCodeUnauthorized = String "unauthorized"
  toJSON DispatcherMessagesRefusalsItemCodeNoneU2d_pending = String "none-pending"

dispatcherMessagesRefusalsItemCodeText :: DispatcherMessagesRefusalsItemCode -> Text
dispatcherMessagesRefusalsItemCodeText DispatcherMessagesRefusalsItemCodePeerU2d_unavailable = "peer-unavailable"
dispatcherMessagesRefusalsItemCodeText DispatcherMessagesRefusalsItemCodeNotU2d_found = "not-found"
dispatcherMessagesRefusalsItemCodeText DispatcherMessagesRefusalsItemCodeUnauthorized = "unauthorized"
dispatcherMessagesRefusalsItemCodeText DispatcherMessagesRefusalsItemCodeNoneU2d_pending = "none-pending"
