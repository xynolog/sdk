-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RootsInitParams (RootsInitParams (..), RootsInitParamsInference (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion

data RootsInitParams = RootsInitParams
  { rootsInitParamsAnthropicEndpoint :: Maybe Text,
    rootsInitParamsApiVersion :: ApiVersion,
    rootsInitParamsConfigName :: Maybe Text,
    rootsInitParamsDomain :: Text,
    rootsInitParamsEmbedding :: Maybe Text,
    rootsInitParamsInference :: Maybe RootsInitParamsInference,
    rootsInitParamsModel :: Maybe Text,
    rootsInitParamsModelLight :: Maybe Text,
    rootsInitParamsName :: Maybe Text,
    rootsInitParamsOllamaBase :: Maybe Text,
    rootsInitParamsOllamaRegistry :: Maybe Text,
    rootsInitParamsPath :: Text,
    rootsInitParamsSiteName :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON RootsInitParams where parseJSON = checked "RootsInitParams" $ withObject "RootsInitParams" (\fields -> RootsInitParams <$> optional fields "anthropicEndpoint" <*> (fields .: "apiVersion") <*> optional fields "configName" <*> (fields .: "domain") <*> optional fields "embedding" <*> optional fields "inference" <*> optional fields "model" <*> optional fields "modelLight" <*> optional fields "name" <*> optional fields "ollamaBase" <*> optional fields "ollamaRegistry" <*> (fields .: "path") <*> optional fields "siteName")

instance ToJSON RootsInitParams where toJSON value = Object (KM.fromList (concat [optionalPair "anthropicEndpoint" (rootsInitParamsAnthropicEndpoint value), [("apiVersion", toJSON (rootsInitParamsApiVersion value))], optionalPair "configName" (rootsInitParamsConfigName value), [("domain", toJSON (rootsInitParamsDomain value))], optionalPair "embedding" (rootsInitParamsEmbedding value), optionalPair "inference" (rootsInitParamsInference value), optionalPair "model" (rootsInitParamsModel value), optionalPair "modelLight" (rootsInitParamsModelLight value), optionalPair "name" (rootsInitParamsName value), optionalPair "ollamaBase" (rootsInitParamsOllamaBase value), optionalPair "ollamaRegistry" (rootsInitParamsOllamaRegistry value), [("path", toJSON (rootsInitParamsPath value))], optionalPair "siteName" (rootsInitParamsSiteName value)]))

data RootsInitParamsInference = RootsInitParamsInferenceAnthropic | RootsInitParamsInferenceOllama deriving (Eq, Show)

instance FromJSON RootsInitParamsInference where parseJSON = checked "RootsInitParamsInference" $ \value -> if value == String "anthropic" then pure RootsInitParamsInferenceAnthropic else if value == String "ollama" then pure RootsInitParamsInferenceOllama else fail "unknown enumeration member"

instance ToJSON RootsInitParamsInference where
  toJSON RootsInitParamsInferenceAnthropic = String "anthropic"
  toJSON RootsInitParamsInferenceOllama = String "ollama"
