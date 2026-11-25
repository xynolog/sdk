-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TagCategory (TagCategory (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data TagCategory = TagCategory
  { tagCategoryDescription :: Text,
    tagCategoryExamples :: [Text],
    tagCategoryName :: Text
  }
  deriving (Eq, Show)

instance FromJSON TagCategory where parseJSON = checked "TagCategory" $ withObject "TagCategory" (\fields -> TagCategory <$> (fields .: "description") <*> (fields .: "examples") <*> (fields .: "name"))

instance ToJSON TagCategory where toJSON value = Object (KM.fromList (concat [[("description", toJSON (tagCategoryDescription value))], [("examples", toJSON (tagCategoryExamples value))], [("name", toJSON (tagCategoryName value))]]))
