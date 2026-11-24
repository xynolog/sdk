-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.OllamaEmbeddingConfig (OllamaEmbeddingConfig (..), OllamaEmbeddingConfigType (..), ollamaEmbeddingConfigTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data OllamaEmbeddingConfig = OllamaEmbeddingConfig
  { ollamaEmbeddingConfigBaseUrl :: Text,
    ollamaEmbeddingConfigModel :: Text,
    ollamaEmbeddingConfigType :: OllamaEmbeddingConfigType
  }
  deriving (Eq, Show)

instance FromJSON OllamaEmbeddingConfig where parseJSON = checked "OllamaEmbeddingConfig" $ withObject "OllamaEmbeddingConfig" (\fields -> OllamaEmbeddingConfig <$> (fields .: "baseUrl") <*> (fields .: "model") <*> (fields .: "type"))

instance ToJSON OllamaEmbeddingConfig where toJSON value = Object (KM.fromList (concat [[("baseUrl", toJSON (ollamaEmbeddingConfigBaseUrl value))], [("model", toJSON (ollamaEmbeddingConfigModel value))], [("type", toJSON (ollamaEmbeddingConfigType value))]]))

data OllamaEmbeddingConfigType = OllamaEmbeddingConfigTypeOllama deriving (Eq, Show)

instance FromJSON OllamaEmbeddingConfigType where parseJSON = checked "OllamaEmbeddingConfigType" $ \value -> if value == String "ollama" then pure OllamaEmbeddingConfigTypeOllama else fail "unknown enumeration member"

instance ToJSON OllamaEmbeddingConfigType where toJSON OllamaEmbeddingConfigTypeOllama = String "ollama"

ollamaEmbeddingConfigTypeText :: OllamaEmbeddingConfigType -> Text
ollamaEmbeddingConfigTypeText OllamaEmbeddingConfigTypeOllama = "ollama"
