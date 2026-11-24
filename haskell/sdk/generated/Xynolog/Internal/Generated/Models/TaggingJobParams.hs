-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TaggingJobParams (TaggingJobParams (..), TaggingJobParamsMotivation (..), taggingJobParamsMotivationText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data TaggingJobParams = TaggingJobParams
  { taggingJobParamsCategories :: [Text],
    taggingJobParamsLanguage :: Maybe Text,
    taggingJobParamsMotivation :: TaggingJobParamsMotivation,
    taggingJobParamsSchemaId :: Text,
    taggingJobParamsSourceLanguage :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON TaggingJobParams where parseJSON = checked "TaggingJobParams" $ withObject "TaggingJobParams" (\fields -> TaggingJobParams <$> (fields .: "categories") <*> optional fields "language" <*> (fields .: "motivation") <*> (fields .: "schemaId") <*> optional fields "sourceLanguage")

instance ToJSON TaggingJobParams where toJSON value = Object (KM.fromList (concat [[("categories", toJSON (taggingJobParamsCategories value))], optionalPair "language" (taggingJobParamsLanguage value), [("motivation", toJSON (taggingJobParamsMotivation value))], [("schemaId", toJSON (taggingJobParamsSchemaId value))], optionalPair "sourceLanguage" (taggingJobParamsSourceLanguage value)]))

data TaggingJobParamsMotivation = TaggingJobParamsMotivationTagging deriving (Eq, Show)

instance FromJSON TaggingJobParamsMotivation where parseJSON = checked "TaggingJobParamsMotivation" $ \value -> if value == String "tagging" then pure TaggingJobParamsMotivationTagging else fail "unknown enumeration member"

instance ToJSON TaggingJobParamsMotivation where toJSON TaggingJobParamsMotivationTagging = String "tagging"

taggingJobParamsMotivationText :: TaggingJobParamsMotivation -> Text
taggingJobParamsMotivationText TaggingJobParamsMotivationTagging = "tagging"
