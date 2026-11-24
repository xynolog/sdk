-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.VectorsConfig (VectorsConfig (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MemoryVectorsConfig
import Xynolog.Internal.Generated.Models.QdrantVectorsConfig

data VectorsConfig = VectorsConfigQdrantVectorsConfig QdrantVectorsConfig | VectorsConfigMemoryVectorsConfig MemoryVectorsConfig deriving (Eq, Show)

instance FromJSON VectorsConfig where parseJSON = checked "VectorsConfig" $ \value -> (VectorsConfigQdrantVectorsConfig <$> parseJSON value) <|> (VectorsConfigMemoryVectorsConfig <$> parseJSON value)

instance ToJSON VectorsConfig where
  toJSON (VectorsConfigQdrantVectorsConfig value) = toJSON value
  toJSON (VectorsConfigMemoryVectorsConfig value) = toJSON value
