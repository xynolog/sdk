-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Engine (Engine (..), EngineProvider (..), engineProviderText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data Engine = Engine
  { engineModel :: Text,
    engineProvider :: EngineProvider
  }
  deriving (Eq, Show)

instance FromJSON Engine where parseJSON = checked "Engine" $ withObject "Engine" (\fields -> Engine <$> (fields .: "model") <*> (fields .: "provider"))

instance ToJSON Engine where toJSON value = Object (KM.fromList (concat [[("model", toJSON (engineModel value))], [("provider", toJSON (engineProvider value))]]))

data EngineProvider = EngineProviderAnthropic | EngineProviderGoogle | EngineProviderLlamacpp | EngineProviderOllama | EngineProviderOpenai | EngineProviderTogether | EngineProviderVllm deriving (Eq, Show)

instance FromJSON EngineProvider where parseJSON = checked "EngineProvider" $ \value -> if value == String "anthropic" then pure EngineProviderAnthropic else if value == String "google" then pure EngineProviderGoogle else if value == String "llamacpp" then pure EngineProviderLlamacpp else if value == String "ollama" then pure EngineProviderOllama else if value == String "openai" then pure EngineProviderOpenai else if value == String "together" then pure EngineProviderTogether else if value == String "vllm" then pure EngineProviderVllm else fail "unknown enumeration member"

instance ToJSON EngineProvider where
  toJSON EngineProviderAnthropic = String "anthropic"
  toJSON EngineProviderGoogle = String "google"
  toJSON EngineProviderLlamacpp = String "llamacpp"
  toJSON EngineProviderOllama = String "ollama"
  toJSON EngineProviderOpenai = String "openai"
  toJSON EngineProviderTogether = String "together"
  toJSON EngineProviderVllm = String "vllm"

engineProviderText :: EngineProvider -> Text
engineProviderText EngineProviderAnthropic = "anthropic"
engineProviderText EngineProviderGoogle = "google"
engineProviderText EngineProviderLlamacpp = "llamacpp"
engineProviderText EngineProviderOllama = "ollama"
engineProviderText EngineProviderOpenai = "openai"
engineProviderText EngineProviderTogether = "together"
engineProviderText EngineProviderVllm = "vllm"
