-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GenerationJobRequest (GenerationJobRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.SupportedMediaType

data GenerationJobRequest = GenerationJobRequest
  { generationJobRequestTitle :: Text,
    generationJobRequestStorageUri :: Text,
    generationJobRequestPrompt :: Maybe Text,
    generationJobRequestEntityTypes :: Maybe [Text],
    generationJobRequestLanguage :: Maybe Text,
    generationJobRequestSourceLanguage :: Maybe Text,
    generationJobRequestTemperature :: Maybe Scientific,
    generationJobRequestMaxTokens :: Maybe Scientific,
    generationJobRequestOutputMediaType :: Maybe SupportedMediaType,
    generationJobRequestTask :: Maybe Text,
    generationJobRequestStructure :: Maybe Text,
    generationJobRequestCite :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON GenerationJobRequest where parseJSON = checked "GenerationJobRequest" $ withObject "GenerationJobRequest" (\fields -> GenerationJobRequest <$> (fields .: "title") <*> (fields .: "storageUri") <*> optional fields "prompt" <*> optional fields "entityTypes" <*> optional fields "language" <*> optional fields "sourceLanguage" <*> optional fields "temperature" <*> optional fields "maxTokens" <*> optional fields "outputMediaType" <*> optional fields "task" <*> optional fields "structure" <*> optional fields "cite")

instance ToJSON GenerationJobRequest where toJSON value = Object (KM.fromList (concat [[("title", toJSON (generationJobRequestTitle value))], [("storageUri", toJSON (generationJobRequestStorageUri value))], optionalPair "prompt" (generationJobRequestPrompt value), optionalPair "entityTypes" (generationJobRequestEntityTypes value), optionalPair "language" (generationJobRequestLanguage value), optionalPair "sourceLanguage" (generationJobRequestSourceLanguage value), optionalPair "temperature" (generationJobRequestTemperature value), optionalPair "maxTokens" (generationJobRequestMaxTokens value), optionalPair "outputMediaType" (generationJobRequestOutputMediaType value), optionalPair "task" (generationJobRequestTask value), optionalPair "structure" (generationJobRequestStructure value), optionalPair "cite" (generationJobRequestCite value)]))
