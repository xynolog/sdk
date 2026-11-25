-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.QdrantVectorsConfig (QdrantVectorsConfig (..), QdrantVectorsConfigType (..), qdrantVectorsConfigTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data QdrantVectorsConfig = QdrantVectorsConfig
  { qdrantVectorsConfigType :: QdrantVectorsConfigType,
    qdrantVectorsConfigHost :: Text,
    qdrantVectorsConfigPort :: Integer,
    qdrantVectorsConfigTokenEnv :: Text
  }
  deriving (Eq, Show)

instance FromJSON QdrantVectorsConfig where parseJSON = checked "QdrantVectorsConfig" $ withObject "QdrantVectorsConfig" (\fields -> QdrantVectorsConfig <$> (fields .: "type") <*> (fields .: "host") <*> (fields .: "port") <*> (fields .: "tokenEnv"))

instance ToJSON QdrantVectorsConfig where toJSON value = Object (KM.fromList (concat [[("type", toJSON (qdrantVectorsConfigType value))], [("host", toJSON (qdrantVectorsConfigHost value))], [("port", toJSON (qdrantVectorsConfigPort value))], [("tokenEnv", toJSON (qdrantVectorsConfigTokenEnv value))]]))

data QdrantVectorsConfigType = QdrantVectorsConfigTypeQdrant deriving (Eq, Show)

instance FromJSON QdrantVectorsConfigType where parseJSON = checked "QdrantVectorsConfigType" $ \value -> if value == String "qdrant" then pure QdrantVectorsConfigTypeQdrant else fail "unknown enumeration member"

instance ToJSON QdrantVectorsConfigType where toJSON QdrantVectorsConfigTypeQdrant = String "qdrant"

qdrantVectorsConfigTypeText :: QdrantVectorsConfigType -> Text
qdrantVectorsConfigTypeText QdrantVectorsConfigTypeQdrant = "qdrant"
