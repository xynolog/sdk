-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RootsInitParams (RootsInitParams (..), RootsInitParamsInference (..), rootsInitParamsInferenceText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion

data RootsInitParams = RootsInitParams
  { rootsInitParamsApiVersion :: ApiVersion,
    rootsInitParamsPath :: Text,
    rootsInitParamsDomain :: Text,
    rootsInitParamsName :: Maybe Text,
    rootsInitParamsSiteName :: Maybe Text,
    rootsInitParamsInference :: Maybe RootsInitParamsInference,
    rootsInitParamsModel :: Maybe Text,
    rootsInitParamsModelLight :: Maybe Text,
    rootsInitParamsEmbedding :: Maybe Text,
    rootsInitParamsConfigName :: Maybe Text,
    rootsInitParamsAnthropicEndpoint :: Maybe Text,
    rootsInitParamsOllamaBase :: Maybe Text,
    rootsInitParamsOllamaRegistry :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON RootsInitParams where parseJSON = checked "RootsInitParams" $ withObject "RootsInitParams" (\fields -> RootsInitParams <$> (fields .: "apiVersion") <*> (fields .: "path") <*> (fields .: "domain") <*> optional fields "name" <*> optional fields "siteName" <*> optional fields "inference" <*> optional fields "model" <*> optional fields "modelLight" <*> optional fields "embedding" <*> optional fields "configName" <*> optional fields "anthropicEndpoint" <*> optional fields "ollamaBase" <*> optional fields "ollamaRegistry")

instance ToJSON RootsInitParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (rootsInitParamsApiVersion value))], [("path", toJSON (rootsInitParamsPath value))], [("domain", toJSON (rootsInitParamsDomain value))], optionalPair "name" (rootsInitParamsName value), optionalPair "siteName" (rootsInitParamsSiteName value), optionalPair "inference" (rootsInitParamsInference value), optionalPair "model" (rootsInitParamsModel value), optionalPair "modelLight" (rootsInitParamsModelLight value), optionalPair "embedding" (rootsInitParamsEmbedding value), optionalPair "configName" (rootsInitParamsConfigName value), optionalPair "anthropicEndpoint" (rootsInitParamsAnthropicEndpoint value), optionalPair "ollamaBase" (rootsInitParamsOllamaBase value), optionalPair "ollamaRegistry" (rootsInitParamsOllamaRegistry value)]))

data RootsInitParamsInference = RootsInitParamsInferenceAnthropic | RootsInitParamsInferenceOllama deriving (Eq, Show)

instance FromJSON RootsInitParamsInference where parseJSON = checked "RootsInitParamsInference" $ \value -> if value == String "anthropic" then pure RootsInitParamsInferenceAnthropic else if value == String "ollama" then pure RootsInitParamsInferenceOllama else fail "unknown enumeration member"

instance ToJSON RootsInitParamsInference where
  toJSON RootsInitParamsInferenceAnthropic = String "anthropic"
  toJSON RootsInitParamsInferenceOllama = String "ollama"

rootsInitParamsInferenceText :: RootsInitParamsInference -> Text
rootsInitParamsInferenceText RootsInitParamsInferenceAnthropic = "anthropic"
rootsInitParamsInferenceText RootsInitParamsInferenceOllama = "ollama"
