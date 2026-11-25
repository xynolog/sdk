-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.VectorsConfig (VectorsConfig (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MemoryVectorsConfig
import Xynolog.Internal.Generated.Models.QdrantVectorsConfig

data VectorsConfig = VectorsConfigQdrantVectorsConfig QdrantVectorsConfig | VectorsConfigMemoryVectorsConfig MemoryVectorsConfig deriving (Eq, Show)

instance FromJSON VectorsConfig where parseJSON = checked "VectorsConfig" $ \value -> readMember "VectorsConfig" [([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "host", "port", "tokenEnv"], signatureAllowed = Just ["type", "host", "port", "tokenEnv"], signatureFixed = [("type", [String "qdrant"])], signaturePattern = Nothing, signatureValues = Nothing}], VectorsConfigQdrantVectorsConfig <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type"], signatureAllowed = Just ["type"], signatureFixed = [("type", [String "memory"])], signaturePattern = Nothing, signatureValues = Nothing}], VectorsConfigMemoryVectorsConfig <$> parseJSON value)] value

instance ToJSON VectorsConfig where
  toJSON (VectorsConfigQdrantVectorsConfig value) = toJSON value
  toJSON (VectorsConfigMemoryVectorsConfig value) = toJSON value
