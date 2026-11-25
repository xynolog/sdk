-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.VectorStore (VectorStore (..), VectorStoreKind (..), vectorStoreKindText, VectorStoreSpec (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Image
import Xynolog.Internal.Generated.Models.Metadata
import Xynolog.Internal.Generated.Models.Resources
import Xynolog.Internal.Generated.Models.StackApiVersion

data VectorStore = VectorStore
  { vectorStoreApiVersion :: StackApiVersion,
    vectorStoreKind :: VectorStoreKind,
    vectorStoreMetadata :: Metadata,
    vectorStoreSpec :: VectorStoreSpec
  }
  deriving (Eq, Show)

instance FromJSON VectorStore where parseJSON = checked "VectorStore" $ withObject "VectorStore" (\fields -> VectorStore <$> (fields .: "apiVersion") <*> (fields .: "kind") <*> (fields .: "metadata") <*> (fields .: "spec"))

instance ToJSON VectorStore where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (vectorStoreApiVersion value))], [("kind", toJSON (vectorStoreKind value))], [("metadata", toJSON (vectorStoreMetadata value))], [("spec", toJSON (vectorStoreSpec value))]]))

data VectorStoreKind = VectorStoreKindVectorStore deriving (Eq, Show)

instance FromJSON VectorStoreKind where parseJSON = checked "VectorStoreKind" $ \value -> if value == String "VectorStore" then pure VectorStoreKindVectorStore else fail "unknown enumeration member"

instance ToJSON VectorStoreKind where toJSON VectorStoreKindVectorStore = String "VectorStore"

vectorStoreKindText :: VectorStoreKind -> Text
vectorStoreKindText VectorStoreKindVectorStore = "VectorStore"

data VectorStoreSpec = VectorStoreSpec
  { vectorStoreSpecType :: Text,
    vectorStoreSpecImage :: Image,
    vectorStoreSpecResources :: Resources,
    vectorStoreSpecPort :: Integer
  }
  deriving (Eq, Show)

instance FromJSON VectorStoreSpec where parseJSON = checked "VectorStoreSpec" $ withObject "VectorStoreSpec" (\fields -> VectorStoreSpec <$> (fields .: "type") <*> (fields .: "image") <*> (fields .: "resources") <*> (fields .: "port"))

instance ToJSON VectorStoreSpec where toJSON value = Object (KM.fromList (concat [[("type", toJSON (vectorStoreSpecType value))], [("image", toJSON (vectorStoreSpecImage value))], [("resources", toJSON (vectorStoreSpecResources value))], [("port", toJSON (vectorStoreSpecPort value))]]))
