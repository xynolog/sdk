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
  { bodyOperationReplaceNewItem :: AnnotationBody,
    bodyOperationReplaceOldItem :: AnnotationBody,
    bodyOperationReplaceOp :: BodyOperationReplaceOp
  }
  deriving (Eq, Show)

instance FromJSON BodyOperationReplace where parseJSON = checked "BodyOperationReplace" $ withObject "BodyOperationReplace" (\fields -> BodyOperationReplace <$> (fields .: "newItem") <*> (fields .: "oldItem") <*> (fields .: "op"))

instance ToJSON BodyOperationReplace where toJSON value = Object (KM.fromList (concat [[("newItem", toJSON (bodyOperationReplaceNewItem value))], [("oldItem", toJSON (bodyOperationReplaceOldItem value))], [("op", toJSON (bodyOperationReplaceOp value))]]))

data BodyOperationReplaceOp = BodyOperationReplaceOpReplace deriving (Eq, Show)

instance FromJSON BodyOperationReplaceOp where parseJSON = checked "BodyOperationReplaceOp" $ \value -> if value == String "replace" then pure BodyOperationReplaceOpReplace else fail "unknown enumeration member"

instance ToJSON BodyOperationReplaceOp where toJSON BodyOperationReplaceOpReplace = String "replace"

bodyOperationReplaceOpText :: BodyOperationReplaceOp -> Text
bodyOperationReplaceOpText BodyOperationReplaceOpReplace = "replace"
