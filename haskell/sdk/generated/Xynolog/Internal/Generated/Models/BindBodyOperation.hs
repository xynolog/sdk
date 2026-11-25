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
  { bindBodyOperationOp :: BindBodyOperationOp,
    bindBodyOperationItem :: Maybe AnnotationBody,
    bindBodyOperationOldItem :: Maybe AnnotationBody,
    bindBodyOperationNewItem :: Maybe AnnotationBody
  }
  deriving (Eq, Show)

instance FromJSON BindBodyOperation where parseJSON = checked "BindBodyOperation" $ withObject "BindBodyOperation" (\fields -> BindBodyOperation <$> (fields .: "op") <*> optional fields "item" <*> optional fields "oldItem" <*> optional fields "newItem")

instance ToJSON BindBodyOperation where toJSON value = Object (KM.fromList (concat [[("op", toJSON (bindBodyOperationOp value))], optionalPair "item" (bindBodyOperationItem value), optionalPair "oldItem" (bindBodyOperationOldItem value), optionalPair "newItem" (bindBodyOperationNewItem value)]))

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
