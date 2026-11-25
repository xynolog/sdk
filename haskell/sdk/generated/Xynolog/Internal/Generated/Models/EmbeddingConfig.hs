-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.EmbeddingConfig (EmbeddingConfig (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.OllamaEmbeddingConfig
import Xynolog.Internal.Generated.Models.VoyageEmbeddingConfig

data EmbeddingConfig = EmbeddingConfigOllamaEmbeddingConfig OllamaEmbeddingConfig | EmbeddingConfigVoyageEmbeddingConfig VoyageEmbeddingConfig deriving (Eq, Show)

instance FromJSON EmbeddingConfig where parseJSON = checked "EmbeddingConfig" $ \value -> readMember "EmbeddingConfig" [([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "model", "baseUrl"], signatureAllowed = Just ["type", "model", "baseUrl"], signatureFixed = [("type", [String "ollama"])], signaturePattern = Nothing, signatureValues = Nothing}], EmbeddingConfigOllamaEmbeddingConfig <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "model", "endpoint", "apiKeyEnv"], signatureAllowed = Just ["type", "model", "endpoint", "apiKeyEnv"], signatureFixed = [("type", [String "voyage"])], signaturePattern = Nothing, signatureValues = Nothing}], EmbeddingConfigVoyageEmbeddingConfig <$> parseJSON value)] value

instance ToJSON EmbeddingConfig where
  toJSON (EmbeddingConfigOllamaEmbeddingConfig value) = toJSON value
  toJSON (EmbeddingConfigVoyageEmbeddingConfig value) = toJSON value
