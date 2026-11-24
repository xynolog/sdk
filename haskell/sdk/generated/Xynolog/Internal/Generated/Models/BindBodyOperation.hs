-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BindBodyOperation (BindBodyOperation (..), BindBodyOperationOp (..), bindBodyOperationOpText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationBody

data BindBodyOperation = BindBodyOperation
  { bindBodyOperationItem :: Maybe AnnotationBody,
    bindBodyOperationNewItem :: Maybe AnnotationBody,
    bindBodyOperationOldItem :: Maybe AnnotationBody,
    bindBodyOperationOp :: BindBodyOperationOp,
    bindBodyOperationAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON BindBodyOperation where parseJSON = checked "BindBodyOperation" $ withObject "BindBodyOperation" (\fields -> BindBodyOperation <$> optional fields "item" <*> optional fields "newItem" <*> optional fields "oldItem" <*> (fields .: "op") <*> traverse parseJSON (withoutFields ["item", "newItem", "oldItem", "op"] fields))

instance ToJSON BindBodyOperation where toJSON value = Object (KM.fromList (concat [optionalPair "item" (bindBodyOperationItem value), optionalPair "newItem" (bindBodyOperationNewItem value), optionalPair "oldItem" (bindBodyOperationOldItem value), [("op", toJSON (bindBodyOperationOp value))]]) <> fmap toJSON (withoutFields ["item", "newItem", "oldItem", "op"] (bindBodyOperationAdditionalProperties value)))

data BindBodyOperationOp = BindBodyOperationOpAdd | BindBodyOperationOpRemove | BindBodyOperationOpReplace deriving (Eq, Show)

instance FromJSON BindBodyOperationOp where parseJSON = checked "BindBodyOperationOp" $ \value -> if value == String "add" then pure BindBodyOperationOpAdd else if value == String "remove" then pure BindBodyOperationOpRemove else if value == String "replace" then pure BindBodyOperationOpReplace else fail "unknown enumeration member"

instance ToJSON BindBodyOperationOp where
  toJSON BindBodyOperationOpAdd = String "add"
  toJSON BindBodyOperationOpRemove = String "remove"
  toJSON BindBodyOperationOpReplace = String "replace"

bindBodyOperationOpText :: BindBodyOperationOp -> Text
bindBodyOperationOpText BindBodyOperationOpAdd = "add"
bindBodyOperationOpText BindBodyOperationOpRemove = "remove"
bindBodyOperationOpText BindBodyOperationOpReplace = "replace"
