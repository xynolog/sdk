-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.HighlightingJobParams (HighlightingJobParams (..), HighlightingJobParamsMotivation (..), highlightingJobParamsMotivationText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec

data HighlightingJobParams = HighlightingJobParams
  { highlightingJobParamsDensity :: Maybe Scientific,
    highlightingJobParamsInstructions :: Maybe Text,
    highlightingJobParamsMotivation :: HighlightingJobParamsMotivation,
    highlightingJobParamsSourceLanguage :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON HighlightingJobParams where parseJSON = checked "HighlightingJobParams" $ withObject "HighlightingJobParams" (\fields -> HighlightingJobParams <$> optional fields "density" <*> optional fields "instructions" <*> (fields .: "motivation") <*> optional fields "sourceLanguage")

instance ToJSON HighlightingJobParams where toJSON value = Object (KM.fromList (concat [optionalPair "density" (highlightingJobParamsDensity value), optionalPair "instructions" (highlightingJobParamsInstructions value), [("motivation", toJSON (highlightingJobParamsMotivation value))], optionalPair "sourceLanguage" (highlightingJobParamsSourceLanguage value)]))

data HighlightingJobParamsMotivation = HighlightingJobParamsMotivationHighlighting deriving (Eq, Show)

instance FromJSON HighlightingJobParamsMotivation where parseJSON = checked "HighlightingJobParamsMotivation" $ \value -> if value == String "highlighting" then pure HighlightingJobParamsMotivationHighlighting else fail "unknown enumeration member"

instance ToJSON HighlightingJobParamsMotivation where toJSON HighlightingJobParamsMotivationHighlighting = String "highlighting"

highlightingJobParamsMotivationText :: HighlightingJobParamsMotivation -> Text
highlightingJobParamsMotivationText HighlightingJobParamsMotivationHighlighting = "highlighting"
