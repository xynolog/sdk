-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TagSchemaAddedPayload (TagSchemaAddedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.TagSchema

data TagSchemaAddedPayload = TagSchemaAddedPayload
  { tagSchemaAddedPayloadSchema :: TagSchema
  }
  deriving (Eq, Show)

instance FromJSON TagSchemaAddedPayload where parseJSON = checked "TagSchemaAddedPayload" $ withObject "TagSchemaAddedPayload" (\fields -> TagSchemaAddedPayload <$> (fields .: "schema"))

instance ToJSON TagSchemaAddedPayload where toJSON value = Object (KM.fromList (concat [[("schema", toJSON (tagSchemaAddedPayloadSchema value))]]))
