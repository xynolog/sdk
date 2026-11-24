-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.CommentingJobParams (CommentingJobParams (..), CommentingJobParamsMotivation (..), commentingJobParamsMotivationText, CommentingJobParamsTone (..), commentingJobParamsToneText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec

data CommentingJobParams = CommentingJobParams
  { commentingJobParamsDensity :: Maybe Scientific,
    commentingJobParamsInstructions :: Maybe Text,
    commentingJobParamsLanguage :: Maybe Text,
    commentingJobParamsMotivation :: CommentingJobParamsMotivation,
    commentingJobParamsSourceLanguage :: Maybe Text,
    commentingJobParamsTone :: Maybe CommentingJobParamsTone
  }
  deriving (Eq, Show)

instance FromJSON CommentingJobParams where parseJSON = checked "CommentingJobParams" $ withObject "CommentingJobParams" (\fields -> CommentingJobParams <$> optional fields "density" <*> optional fields "instructions" <*> optional fields "language" <*> (fields .: "motivation") <*> optional fields "sourceLanguage" <*> optional fields "tone")

instance ToJSON CommentingJobParams where toJSON value = Object (KM.fromList (concat [optionalPair "density" (commentingJobParamsDensity value), optionalPair "instructions" (commentingJobParamsInstructions value), optionalPair "language" (commentingJobParamsLanguage value), [("motivation", toJSON (commentingJobParamsMotivation value))], optionalPair "sourceLanguage" (commentingJobParamsSourceLanguage value), optionalPair "tone" (commentingJobParamsTone value)]))

data CommentingJobParamsMotivation = CommentingJobParamsMotivationCommenting deriving (Eq, Show)

instance FromJSON CommentingJobParamsMotivation where parseJSON = checked "CommentingJobParamsMotivation" $ \value -> if value == String "commenting" then pure CommentingJobParamsMotivationCommenting else fail "unknown enumeration member"

instance ToJSON CommentingJobParamsMotivation where toJSON CommentingJobParamsMotivationCommenting = String "commenting"

commentingJobParamsMotivationText :: CommentingJobParamsMotivation -> Text
commentingJobParamsMotivationText CommentingJobParamsMotivationCommenting = "commenting"

data CommentingJobParamsTone = CommentingJobParamsToneScholarly | CommentingJobParamsToneExplanatory | CommentingJobParamsToneConversational | CommentingJobParamsToneTechnical deriving (Eq, Show)

instance FromJSON CommentingJobParamsTone where parseJSON = checked "CommentingJobParamsTone" $ \value -> if value == String "scholarly" then pure CommentingJobParamsToneScholarly else if value == String "explanatory" then pure CommentingJobParamsToneExplanatory else if value == String "conversational" then pure CommentingJobParamsToneConversational else if value == String "technical" then pure CommentingJobParamsToneTechnical else fail "unknown enumeration member"

instance ToJSON CommentingJobParamsTone where
  toJSON CommentingJobParamsToneScholarly = String "scholarly"
  toJSON CommentingJobParamsToneExplanatory = String "explanatory"
  toJSON CommentingJobParamsToneConversational = String "conversational"
  toJSON CommentingJobParamsToneTechnical = String "technical"

commentingJobParamsToneText :: CommentingJobParamsTone -> Text
commentingJobParamsToneText CommentingJobParamsToneScholarly = "scholarly"
commentingJobParamsToneText CommentingJobParamsToneExplanatory = "explanatory"
commentingJobParamsToneText CommentingJobParamsToneConversational = "conversational"
commentingJobParamsToneText CommentingJobParamsToneTechnical = "technical"
