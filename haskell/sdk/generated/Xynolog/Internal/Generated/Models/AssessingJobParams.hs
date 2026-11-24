-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AssessingJobParams (AssessingJobParams (..), AssessingJobParamsMotivation (..), assessingJobParamsMotivationText, AssessingJobParamsTone (..), assessingJobParamsToneText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec

data AssessingJobParams = AssessingJobParams
  { assessingJobParamsDensity :: Maybe Scientific,
    assessingJobParamsInstructions :: Maybe Text,
    assessingJobParamsLanguage :: Maybe Text,
    assessingJobParamsMotivation :: AssessingJobParamsMotivation,
    assessingJobParamsSourceLanguage :: Maybe Text,
    assessingJobParamsTone :: Maybe AssessingJobParamsTone
  }
  deriving (Eq, Show)

instance FromJSON AssessingJobParams where parseJSON = checked "AssessingJobParams" $ withObject "AssessingJobParams" (\fields -> AssessingJobParams <$> optional fields "density" <*> optional fields "instructions" <*> optional fields "language" <*> (fields .: "motivation") <*> optional fields "sourceLanguage" <*> optional fields "tone")

instance ToJSON AssessingJobParams where toJSON value = Object (KM.fromList (concat [optionalPair "density" (assessingJobParamsDensity value), optionalPair "instructions" (assessingJobParamsInstructions value), optionalPair "language" (assessingJobParamsLanguage value), [("motivation", toJSON (assessingJobParamsMotivation value))], optionalPair "sourceLanguage" (assessingJobParamsSourceLanguage value), optionalPair "tone" (assessingJobParamsTone value)]))

data AssessingJobParamsMotivation = AssessingJobParamsMotivationAssessing deriving (Eq, Show)

instance FromJSON AssessingJobParamsMotivation where parseJSON = checked "AssessingJobParamsMotivation" $ \value -> if value == String "assessing" then pure AssessingJobParamsMotivationAssessing else fail "unknown enumeration member"

instance ToJSON AssessingJobParamsMotivation where toJSON AssessingJobParamsMotivationAssessing = String "assessing"

assessingJobParamsMotivationText :: AssessingJobParamsMotivation -> Text
assessingJobParamsMotivationText AssessingJobParamsMotivationAssessing = "assessing"

data AssessingJobParamsTone = AssessingJobParamsToneAnalytical | AssessingJobParamsToneCritical | AssessingJobParamsToneBalanced | AssessingJobParamsToneConstructive deriving (Eq, Show)

instance FromJSON AssessingJobParamsTone where parseJSON = checked "AssessingJobParamsTone" $ \value -> if value == String "analytical" then pure AssessingJobParamsToneAnalytical else if value == String "critical" then pure AssessingJobParamsToneCritical else if value == String "balanced" then pure AssessingJobParamsToneBalanced else if value == String "constructive" then pure AssessingJobParamsToneConstructive else fail "unknown enumeration member"

instance ToJSON AssessingJobParamsTone where
  toJSON AssessingJobParamsToneAnalytical = String "analytical"
  toJSON AssessingJobParamsToneCritical = String "critical"
  toJSON AssessingJobParamsToneBalanced = String "balanced"
  toJSON AssessingJobParamsToneConstructive = String "constructive"

assessingJobParamsToneText :: AssessingJobParamsTone -> Text
assessingJobParamsToneText AssessingJobParamsToneAnalytical = "analytical"
assessingJobParamsToneText AssessingJobParamsToneCritical = "critical"
assessingJobParamsToneText AssessingJobParamsToneBalanced = "balanced"
assessingJobParamsToneText AssessingJobParamsToneConstructive = "constructive"
