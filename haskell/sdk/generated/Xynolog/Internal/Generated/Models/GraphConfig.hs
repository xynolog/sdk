-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GraphConfig (GraphConfig (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JanusGraphConfig
import Xynolog.Internal.Generated.Models.MemoryGraphConfig
import Xynolog.Internal.Generated.Models.Neo4jGraphConfig
import Xynolog.Internal.Generated.Models.NeptuneGraphConfig

data GraphConfig = GraphConfigNeo4jGraphConfig Neo4jGraphConfig | GraphConfigJanusGraphConfig JanusGraphConfig | GraphConfigNeptuneGraphConfig NeptuneGraphConfig | GraphConfigMemoryGraphConfig MemoryGraphConfig deriving (Eq, Show)

instance FromJSON GraphConfig where parseJSON = checked "GraphConfig" $ \value -> readMember "GraphConfig" [([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "uri", "username", "passwordEnv", "database"], signatureAllowed = Just ["type", "uri", "username", "passwordEnv", "database"], signatureFixed = [("type", [String "neo4j"])], signaturePattern = Nothing, signatureValues = Nothing}], GraphConfigNeo4jGraphConfig <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "host", "port"], signatureAllowed = Just ["type", "host", "port"], signatureFixed = [("type", [String "janusgraph"])], signaturePattern = Nothing, signatureValues = Nothing}], GraphConfigJanusGraphConfig <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "endpoint", "port"], signatureAllowed = Just ["type", "endpoint", "port"], signatureFixed = [("type", [String "neptune"])], signaturePattern = Nothing, signatureValues = Nothing}], GraphConfigNeptuneGraphConfig <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type"], signatureAllowed = Just ["type"], signatureFixed = [("type", [String "memory"])], signaturePattern = Nothing, signatureValues = Nothing}], GraphConfigMemoryGraphConfig <$> parseJSON value)] value

instance ToJSON GraphConfig where
  toJSON (GraphConfigNeo4jGraphConfig value) = toJSON value
  toJSON (GraphConfigJanusGraphConfig value) = toJSON value
  toJSON (GraphConfigNeptuneGraphConfig value) = toJSON value
  toJSON (GraphConfigMemoryGraphConfig value) = toJSON value
