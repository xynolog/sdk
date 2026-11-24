-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.VoyageEmbeddingConfig (VoyageEmbeddingConfig (..), VoyageEmbeddingConfigType (..), voyageEmbeddingConfigTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data VoyageEmbeddingConfig = VoyageEmbeddingConfig
  { voyageEmbeddingConfigApiKeyEnv :: Text,
    voyageEmbeddingConfigEndpoint :: Text,
    voyageEmbeddingConfigModel :: Text,
    voyageEmbeddingConfigType :: VoyageEmbeddingConfigType
  }
  deriving (Eq, Show)

instance FromJSON VoyageEmbeddingConfig where parseJSON = checked "VoyageEmbeddingConfig" $ withObject "VoyageEmbeddingConfig" (\fields -> VoyageEmbeddingConfig <$> (fields .: "apiKeyEnv") <*> (fields .: "endpoint") <*> (fields .: "model") <*> (fields .: "type"))

instance ToJSON VoyageEmbeddingConfig where toJSON value = Object (KM.fromList (concat [[("apiKeyEnv", toJSON (voyageEmbeddingConfigApiKeyEnv value))], [("endpoint", toJSON (voyageEmbeddingConfigEndpoint value))], [("model", toJSON (voyageEmbeddingConfigModel value))], [("type", toJSON (voyageEmbeddingConfigType value))]]))

data VoyageEmbeddingConfigType = VoyageEmbeddingConfigTypeVoyage deriving (Eq, Show)

instance FromJSON VoyageEmbeddingConfigType where parseJSON = checked "VoyageEmbeddingConfigType" $ \value -> if value == String "voyage" then pure VoyageEmbeddingConfigTypeVoyage else fail "unknown enumeration member"

instance ToJSON VoyageEmbeddingConfigType where toJSON VoyageEmbeddingConfigTypeVoyage = String "voyage"

voyageEmbeddingConfigTypeText :: VoyageEmbeddingConfigType -> Text
voyageEmbeddingConfigTypeText VoyageEmbeddingConfigTypeVoyage = "voyage"
