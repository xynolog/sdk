-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GraphConfig (GraphConfig (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JanusGraphConfig
import Xynolog.Internal.Generated.Models.MemoryGraphConfig
import Xynolog.Internal.Generated.Models.Neo4jGraphConfig
import Xynolog.Internal.Generated.Models.NeptuneGraphConfig

data GraphConfig = GraphConfigNeo4jGraphConfig Neo4jGraphConfig | GraphConfigJanusGraphConfig JanusGraphConfig | GraphConfigNeptuneGraphConfig NeptuneGraphConfig | GraphConfigMemoryGraphConfig MemoryGraphConfig deriving (Eq, Show)

instance FromJSON GraphConfig where parseJSON = checked "GraphConfig" $ \value -> (GraphConfigNeo4jGraphConfig <$> parseJSON value) <|> (GraphConfigJanusGraphConfig <$> parseJSON value) <|> (GraphConfigNeptuneGraphConfig <$> parseJSON value) <|> (GraphConfigMemoryGraphConfig <$> parseJSON value)

instance ToJSON GraphConfig where
  toJSON (GraphConfigNeo4jGraphConfig value) = toJSON value
  toJSON (GraphConfigJanusGraphConfig value) = toJSON value
  toJSON (GraphConfigNeptuneGraphConfig value) = toJSON value
  toJSON (GraphConfigMemoryGraphConfig value) = toJSON value
