-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FieldFault (FieldFault (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data FieldFault = FieldFault
  { fieldFaultField :: Text,
    fieldFaultMessage :: Text
  }
  deriving (Eq, Show)

instance FromJSON FieldFault where parseJSON = checked "FieldFault" $ withObject "FieldFault" (\fields -> FieldFault <$> (fields .: "field") <*> (fields .: "message"))

instance ToJSON FieldFault where toJSON value = Object (KM.fromList (concat [[("field", toJSON (fieldFaultField value))], [("message", toJSON (fieldFaultMessage value))]]))
