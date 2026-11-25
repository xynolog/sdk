-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.CreateFromTokenOptions (CreateFromTokenOptions (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data CreateFromTokenOptions = CreateFromTokenOptions
  { createFromTokenOptionsToken :: Text,
    createFromTokenOptionsName :: Text,
    createFromTokenOptionsContent :: Text,
    createFromTokenOptionsArchiveOriginal :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON CreateFromTokenOptions where parseJSON = checked "CreateFromTokenOptions" $ withObject "CreateFromTokenOptions" (\fields -> CreateFromTokenOptions <$> (fields .: "token") <*> (fields .: "name") <*> (fields .: "content") <*> optional fields "archiveOriginal")

instance ToJSON CreateFromTokenOptions where toJSON value = Object (KM.fromList (concat [[("token", toJSON (createFromTokenOptionsToken value))], [("name", toJSON (createFromTokenOptionsName value))], [("content", toJSON (createFromTokenOptionsContent value))], optionalPair "archiveOriginal" (createFromTokenOptionsArchiveOriginal value)]))
