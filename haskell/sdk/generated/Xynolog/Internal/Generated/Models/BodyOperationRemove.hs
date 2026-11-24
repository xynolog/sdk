-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BodyOperationRemove (BodyOperationRemove (..), BodyOperationRemoveOp (..), bodyOperationRemoveOpText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationBody

data BodyOperationRemove = BodyOperationRemove
  { bodyOperationRemoveItem :: AnnotationBody,
    bodyOperationRemoveOp :: BodyOperationRemoveOp,
    bodyOperationRemoveAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON BodyOperationRemove where parseJSON = checked "BodyOperationRemove" $ withObject "BodyOperationRemove" (\fields -> BodyOperationRemove <$> (fields .: "item") <*> (fields .: "op") <*> traverse parseJSON (withoutFields ["item", "op"] fields))

instance ToJSON BodyOperationRemove where toJSON value = Object (KM.fromList (concat [[("item", toJSON (bodyOperationRemoveItem value))], [("op", toJSON (bodyOperationRemoveOp value))]]) <> fmap toJSON (withoutFields ["item", "op"] (bodyOperationRemoveAdditionalProperties value)))

data BodyOperationRemoveOp = BodyOperationRemoveOpRemove deriving (Eq, Show)

instance FromJSON BodyOperationRemoveOp where parseJSON = checked "BodyOperationRemoveOp" $ \value -> if value == String "remove" then pure BodyOperationRemoveOpRemove else fail "unknown enumeration member"

instance ToJSON BodyOperationRemoveOp where toJSON BodyOperationRemoveOpRemove = String "remove"

bodyOperationRemoveOpText :: BodyOperationRemoveOp -> Text
bodyOperationRemoveOpText BodyOperationRemoveOpRemove = "remove"
