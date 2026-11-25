-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FrameAddTagSchemaCommand (FrameAddTagSchemaCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.TagSchema
import Xynolog.Internal.Generated.Models.UserId

data FrameAddTagSchemaCommand = FrameAddTagSchemaCommand
  { frameAddTagSchemaCommandUserId :: Maybe UserId,
    frameAddTagSchemaCommandSchema :: TagSchema,
    frameAddTagSchemaCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON FrameAddTagSchemaCommand where parseJSON = checked "FrameAddTagSchemaCommand" $ withObject "FrameAddTagSchemaCommand" (\fields -> FrameAddTagSchemaCommand <$> optional fields "_userId" <*> (fields .: "schema") <*> traverse parseJSON (withoutFields ["_userId", "schema"] fields))

instance ToJSON FrameAddTagSchemaCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (frameAddTagSchemaCommandUserId value), [("schema", toJSON (frameAddTagSchemaCommandSchema value))]]) <> fmap toJSON (withoutFields ["_userId", "schema"] (frameAddTagSchemaCommandAdditionalProperties value)))
