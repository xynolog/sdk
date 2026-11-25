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
  { frameAddTagSchemaCommandSchema :: TagSchema,
    frameAddTagSchemaCommandUserId :: Maybe UserId
  }
  deriving (Eq, Show)

instance FromJSON FrameAddTagSchemaCommand where parseJSON = checked "FrameAddTagSchemaCommand" $ withObject "FrameAddTagSchemaCommand" (\fields -> FrameAddTagSchemaCommand <$> (fields .: "schema") <*> optional fields "_userId")

instance ToJSON FrameAddTagSchemaCommand where toJSON value = Object (KM.fromList (concat [[("schema", toJSON (frameAddTagSchemaCommandSchema value))], optionalPair "_userId" (frameAddTagSchemaCommandUserId value)]))
