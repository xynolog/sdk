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
  { generationJobParamsTitle :: Text,
    generationJobParamsStorageUri :: Text,
    generationJobParamsPrompt :: Maybe Text,
    generationJobParamsEntityTypes :: Maybe [Text],
    generationJobParamsLanguage :: Maybe Text,
    generationJobParamsSourceLanguage :: Maybe Text,
    generationJobParamsTemperature :: Maybe Scientific,
    generationJobParamsMaxTokens :: Maybe Scientific,
    generationJobParamsOutputMediaType :: Maybe SupportedMediaType,
    generationJobParamsTask :: Maybe Text,
    generationJobParamsStructure :: Maybe Text,
    generationJobParamsCite :: Maybe Bool,
    generationJobParamsContext :: GatheredContext
  }
  deriving (Eq, Show)

instance FromJSON GenerationJobParams where parseJSON = checked "GenerationJobParams" $ withObject "GenerationJobParams" (\fields -> GenerationJobParams <$> (fields .: "title") <*> (fields .: "storageUri") <*> optional fields "prompt" <*> optional fields "entityTypes" <*> optional fields "language" <*> optional fields "sourceLanguage" <*> optional fields "temperature" <*> optional fields "maxTokens" <*> optional fields "outputMediaType" <*> optional fields "task" <*> optional fields "structure" <*> optional fields "cite" <*> (fields .: "context"))

instance ToJSON GenerationJobParams where toJSON value = Object (KM.fromList (concat [[("title", toJSON (generationJobParamsTitle value))], [("storageUri", toJSON (generationJobParamsStorageUri value))], optionalPair "prompt" (generationJobParamsPrompt value), optionalPair "entityTypes" (generationJobParamsEntityTypes value), optionalPair "language" (generationJobParamsLanguage value), optionalPair "sourceLanguage" (generationJobParamsSourceLanguage value), optionalPair "temperature" (generationJobParamsTemperature value), optionalPair "maxTokens" (generationJobParamsMaxTokens value), optionalPair "outputMediaType" (generationJobParamsOutputMediaType value), optionalPair "task" (generationJobParamsTask value), optionalPair "structure" (generationJobParamsStructure value), optionalPair "cite" (generationJobParamsCite value), [("context", toJSON (generationJobParamsContext value))]]))
