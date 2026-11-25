-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BodyOperationAdd (BodyOperationAdd (..), BodyOperationAddOp (..), bodyOperationAddOpText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationBody

data BodyOperationAdd = BodyOperationAdd
  { bodyOperationAddOp :: BodyOperationAddOp,
    bodyOperationAddItem :: AnnotationBody
  }
  deriving (Eq, Show)

instance FromJSON BodyOperationAdd where parseJSON = checked "BodyOperationAdd" $ withObject "BodyOperationAdd" (\fields -> BodyOperationAdd <$> (fields .: "op") <*> (fields .: "item"))

instance ToJSON BodyOperationAdd where toJSON value = Object (KM.fromList (concat [[("op", toJSON (bodyOperationAddOp value))], [("item", toJSON (bodyOperationAddItem value))]]))

data BodyOperationAddOp = BodyOperationAddOpAdd deriving (Eq, Show)

instance FromJSON BodyOperationAddOp where parseJSON = checked "BodyOperationAddOp" $ \value -> if value == String "add" then pure BodyOperationAddOpAdd else fail "unknown enumeration member"

instance ToJSON BodyOperationAddOp where toJSON BodyOperationAddOpAdd = String "add"

bodyOperationAddOpText :: BodyOperationAddOp -> Text
bodyOperationAddOpText BodyOperationAddOpAdd = "add"
