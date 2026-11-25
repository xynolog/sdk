-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TagCategory (TagCategory (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data TagCategory = TagCategory
  { tagCategoryName :: Text,
    tagCategoryDescription :: Text,
    tagCategoryExamples :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON TagCategory where parseJSON = checked "TagCategory" $ withObject "TagCategory" (\fields -> TagCategory <$> (fields .: "name") <*> (fields .: "description") <*> (fields .: "examples"))

instance ToJSON TagCategory where toJSON value = Object (KM.fromList (concat [[("name", toJSON (tagCategoryName value))], [("description", toJSON (tagCategoryDescription value))], [("examples", toJSON (tagCategoryExamples value))]]))
