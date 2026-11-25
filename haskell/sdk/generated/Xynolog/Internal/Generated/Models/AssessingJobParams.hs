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
  { assessingJobParamsMotivation :: AssessingJobParamsMotivation,
    assessingJobParamsInstructions :: Maybe Text,
    assessingJobParamsTone :: Maybe AssessingJobParamsTone,
    assessingJobParamsDensity :: Maybe Scientific,
    assessingJobParamsLanguage :: Maybe Text,
    assessingJobParamsSourceLanguage :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON AssessingJobParams where parseJSON = checked "AssessingJobParams" $ withObject "AssessingJobParams" (\fields -> AssessingJobParams <$> (fields .: "motivation") <*> optional fields "instructions" <*> optional fields "tone" <*> optional fields "density" <*> optional fields "language" <*> optional fields "sourceLanguage")

instance ToJSON AssessingJobParams where toJSON value = Object (KM.fromList (concat [[("motivation", toJSON (assessingJobParamsMotivation value))], optionalPair "instructions" (assessingJobParamsInstructions value), optionalPair "tone" (assessingJobParamsTone value), optionalPair "density" (assessingJobParamsDensity value), optionalPair "language" (assessingJobParamsLanguage value), optionalPair "sourceLanguage" (assessingJobParamsSourceLanguage value)]))

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
