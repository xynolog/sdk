-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GenerationJobParams (GenerationJobParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GatheredContext
import Xynolog.Internal.Generated.Models.SupportedMediaType

data GenerationJobParams = GenerationJobParams
  { generationJobParamsCite :: Maybe Bool,
    generationJobParamsContext :: GatheredContext,
    generationJobParamsEntityTypes :: Maybe [Text],
    generationJobParamsLanguage :: Maybe Text,
    generationJobParamsMaxTokens :: Maybe Scientific,
    generationJobParamsOutputMediaType :: Maybe SupportedMediaType,
    generationJobParamsPrompt :: Maybe Text,
    generationJobParamsSourceLanguage :: Maybe Text,
    generationJobParamsStorageUri :: Text,
    generationJobParamsStructure :: Maybe Text,
    generationJobParamsTask :: Maybe Text,
    generationJobParamsTemperature :: Maybe Scientific,
    generationJobParamsTitle :: Text
  }
  deriving (Eq, Show)

instance FromJSON GenerationJobParams where parseJSON = checked "GenerationJobParams" $ withObject "GenerationJobParams" (\fields -> GenerationJobParams <$> optional fields "cite" <*> (fields .: "context") <*> optional fields "entityTypes" <*> optional fields "language" <*> optional fields "maxTokens" <*> optional fields "outputMediaType" <*> optional fields "prompt" <*> optional fields "sourceLanguage" <*> (fields .: "storageUri") <*> optional fields "structure" <*> optional fields "task" <*> optional fields "temperature" <*> (fields .: "title"))

instance ToJSON GenerationJobParams where toJSON value = Object (KM.fromList (concat [optionalPair "cite" (generationJobParamsCite value), [("context", toJSON (generationJobParamsContext value))], optionalPair "entityTypes" (generationJobParamsEntityTypes value), optionalPair "language" (generationJobParamsLanguage value), optionalPair "maxTokens" (generationJobParamsMaxTokens value), optionalPair "outputMediaType" (generationJobParamsOutputMediaType value), optionalPair "prompt" (generationJobParamsPrompt value), optionalPair "sourceLanguage" (generationJobParamsSourceLanguage value), [("storageUri", toJSON (generationJobParamsStorageUri value))], optionalPair "structure" (generationJobParamsStructure value), optionalPair "task" (generationJobParamsTask value), optionalPair "temperature" (generationJobParamsTemperature value), [("title", toJSON (generationJobParamsTitle value))]]))
