-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TagSchema (TagSchema (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.TagCategory

data TagSchema = TagSchema
  { tagSchemaDescription :: Text,
    tagSchemaDomain :: Text,
    tagSchemaId :: Text,
    tagSchemaName :: Text,
    tagSchemaTags :: [TagCategory]
  }
  deriving (Eq, Show)

instance FromJSON TagSchema where parseJSON = checked "TagSchema" $ withObject "TagSchema" (\fields -> TagSchema <$> (fields .: "description") <*> (fields .: "domain") <*> (fields .: "id") <*> (fields .: "name") <*> (fields .: "tags"))

instance ToJSON TagSchema where toJSON value = Object (KM.fromList (concat [[("description", toJSON (tagSchemaDescription value))], [("domain", toJSON (tagSchemaDomain value))], [("id", toJSON (tagSchemaId value))], [("name", toJSON (tagSchemaName value))], [("tags", toJSON (tagSchemaTags value))]]))
