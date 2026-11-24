-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.EmbeddingConfig (EmbeddingConfig (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.OllamaEmbeddingConfig
import Xynolog.Internal.Generated.Models.VoyageEmbeddingConfig

data EmbeddingConfig = EmbeddingConfigOllamaEmbeddingConfig OllamaEmbeddingConfig | EmbeddingConfigVoyageEmbeddingConfig VoyageEmbeddingConfig deriving (Eq, Show)

instance FromJSON EmbeddingConfig where parseJSON = checked "EmbeddingConfig" $ \value -> (EmbeddingConfigOllamaEmbeddingConfig <$> parseJSON value) <|> (EmbeddingConfigVoyageEmbeddingConfig <$> parseJSON value)

instance ToJSON EmbeddingConfig where
  toJSON (EmbeddingConfigOllamaEmbeddingConfig value) = toJSON value
  toJSON (EmbeddingConfigVoyageEmbeddingConfig value) = toJSON value
