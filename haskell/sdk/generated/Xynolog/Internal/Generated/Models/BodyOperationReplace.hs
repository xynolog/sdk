-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BodyOperationReplace (BodyOperationReplace (..), BodyOperationReplaceOp (..), bodyOperationReplaceOpText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationBody

data BodyOperationReplace = BodyOperationReplace
  { bodyOperationReplaceOp :: BodyOperationReplaceOp,
    bodyOperationReplaceOldItem :: AnnotationBody,
    bodyOperationReplaceNewItem :: AnnotationBody
  }
  deriving (Eq, Show)

instance FromJSON BodyOperationReplace where parseJSON = checked "BodyOperationReplace" $ withObject "BodyOperationReplace" (\fields -> BodyOperationReplace <$> (fields .: "op") <*> (fields .: "oldItem") <*> (fields .: "newItem"))

instance ToJSON BodyOperationReplace where toJSON value = Object (KM.fromList (concat [[("op", toJSON (bodyOperationReplaceOp value))], [("oldItem", toJSON (bodyOperationReplaceOldItem value))], [("newItem", toJSON (bodyOperationReplaceNewItem value))]]))

data BodyOperationReplaceOp = BodyOperationReplaceOpReplace deriving (Eq, Show)

instance FromJSON BodyOperationReplaceOp where parseJSON = checked "BodyOperationReplaceOp" $ \value -> if value == String "replace" then pure BodyOperationReplaceOpReplace else fail "unknown enumeration member"

instance ToJSON BodyOperationReplaceOp where toJSON BodyOperationReplaceOpReplace = String "replace"

bodyOperationReplaceOpText :: BodyOperationReplaceOp -> Text
bodyOperationReplaceOpText BodyOperationReplaceOpReplace = "replace"
