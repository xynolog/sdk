-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.EntityTagChangedPayload (EntityTagChangedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data EntityTagChangedPayload = EntityTagChangedPayload
  { entityTagChangedPayloadEntityType :: Text
  }
  deriving (Eq, Show)

instance FromJSON EntityTagChangedPayload where parseJSON = checked "EntityTagChangedPayload" $ withObject "EntityTagChangedPayload" (\fields -> EntityTagChangedPayload <$> (fields .: "entityType"))

instance ToJSON EntityTagChangedPayload where toJSON value = Object (KM.fromList (concat [[("entityType", toJSON (entityTagChangedPayloadEntityType value))]]))
