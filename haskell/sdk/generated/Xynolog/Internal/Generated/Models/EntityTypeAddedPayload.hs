-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.EntityTypeAddedPayload (EntityTypeAddedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data EntityTypeAddedPayload = EntityTypeAddedPayload
  { entityTypeAddedPayloadEntityType :: Text
  }
  deriving (Eq, Show)

instance FromJSON EntityTypeAddedPayload where parseJSON = checked "EntityTypeAddedPayload" $ withObject "EntityTypeAddedPayload" (\fields -> EntityTypeAddedPayload <$> (fields .: "entityType"))

instance ToJSON EntityTypeAddedPayload where toJSON value = Object (KM.fromList (concat [[("entityType", toJSON (entityTypeAddedPayloadEntityType value))]]))
