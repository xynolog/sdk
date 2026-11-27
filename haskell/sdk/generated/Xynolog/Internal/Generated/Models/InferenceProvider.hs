-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.InferenceProvider (InferenceProvider (..), inferenceProviderText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data InferenceProvider = InferenceProviderAnthropic | InferenceProviderGoogle | InferenceProviderLlamacpp | InferenceProviderOllama | InferenceProviderOpenai | InferenceProviderTogether | InferenceProviderVllm deriving (Eq, Show)

instance FromJSON InferenceProvider where parseJSON = checked "InferenceProvider" $ \value -> if value == String "anthropic" then pure InferenceProviderAnthropic else if value == String "google" then pure InferenceProviderGoogle else if value == String "llamacpp" then pure InferenceProviderLlamacpp else if value == String "ollama" then pure InferenceProviderOllama else if value == String "openai" then pure InferenceProviderOpenai else if value == String "together" then pure InferenceProviderTogether else if value == String "vllm" then pure InferenceProviderVllm else fail "unknown enumeration member"

instance ToJSON InferenceProvider where
  toJSON InferenceProviderAnthropic = String "anthropic"
  toJSON InferenceProviderGoogle = String "google"
  toJSON InferenceProviderLlamacpp = String "llamacpp"
  toJSON InferenceProviderOllama = String "ollama"
  toJSON InferenceProviderOpenai = String "openai"
  toJSON InferenceProviderTogether = String "together"
  toJSON InferenceProviderVllm = String "vllm"

inferenceProviderText :: InferenceProvider -> Text
inferenceProviderText InferenceProviderAnthropic = "anthropic"
inferenceProviderText InferenceProviderGoogle = "google"
inferenceProviderText InferenceProviderLlamacpp = "llamacpp"
inferenceProviderText InferenceProviderOllama = "ollama"
inferenceProviderText InferenceProviderOpenai = "openai"
inferenceProviderText InferenceProviderTogether = "together"
inferenceProviderText InferenceProviderVllm = "vllm"
