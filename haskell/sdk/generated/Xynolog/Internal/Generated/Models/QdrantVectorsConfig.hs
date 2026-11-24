-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.QdrantVectorsConfig (QdrantVectorsConfig (..), QdrantVectorsConfigType (..), qdrantVectorsConfigTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data QdrantVectorsConfig = QdrantVectorsConfig
  { qdrantVectorsConfigHost :: Text,
    qdrantVectorsConfigPort :: Integer,
    qdrantVectorsConfigTokenEnv :: Text,
    qdrantVectorsConfigType :: QdrantVectorsConfigType
  }
  deriving (Eq, Show)

instance FromJSON QdrantVectorsConfig where parseJSON = checked "QdrantVectorsConfig" $ withObject "QdrantVectorsConfig" (\fields -> QdrantVectorsConfig <$> (fields .: "host") <*> (fields .: "port") <*> (fields .: "tokenEnv") <*> (fields .: "type"))

instance ToJSON QdrantVectorsConfig where toJSON value = Object (KM.fromList (concat [[("host", toJSON (qdrantVectorsConfigHost value))], [("port", toJSON (qdrantVectorsConfigPort value))], [("tokenEnv", toJSON (qdrantVectorsConfigTokenEnv value))], [("type", toJSON (qdrantVectorsConfigType value))]]))

data QdrantVectorsConfigType = QdrantVectorsConfigTypeQdrant deriving (Eq, Show)

instance FromJSON QdrantVectorsConfigType where parseJSON = checked "QdrantVectorsConfigType" $ \value -> if value == String "qdrant" then pure QdrantVectorsConfigTypeQdrant else fail "unknown enumeration member"

instance ToJSON QdrantVectorsConfigType where toJSON QdrantVectorsConfigTypeQdrant = String "qdrant"

qdrantVectorsConfigTypeText :: QdrantVectorsConfigType -> Text
qdrantVectorsConfigTypeText QdrantVectorsConfigTypeQdrant = "qdrant"
