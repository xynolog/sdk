-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GraphResourceNode (GraphResourceNode (..), GraphResourceNodeMetadata (..), GraphResourceNodeType (..), graphResourceNodeTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data GraphResourceNode = GraphResourceNode
  { graphResourceNodeEntityTypes :: Maybe [Text],
    graphResourceNodeId :: ResourceId,
    graphResourceNodeLabel :: Text,
    graphResourceNodeMetadata :: Maybe GraphResourceNodeMetadata,
    graphResourceNodeType :: GraphResourceNodeType
  }
  deriving (Eq, Show)

instance FromJSON GraphResourceNode where parseJSON = checked "GraphResourceNode" $ withObject "GraphResourceNode" (\fields -> GraphResourceNode <$> optional fields "entityTypes" <*> (fields .: "id") <*> (fields .: "label") <*> optional fields "metadata" <*> (fields .: "type"))

instance ToJSON GraphResourceNode where toJSON value = Object (KM.fromList (concat [optionalPair "entityTypes" (graphResourceNodeEntityTypes value), [("id", toJSON (graphResourceNodeId value))], [("label", toJSON (graphResourceNodeLabel value))], optionalPair "metadata" (graphResourceNodeMetadata value), [("type", toJSON (graphResourceNodeType value))]]))

data GraphResourceNodeMetadata = GraphResourceNodeMetadata
  { graphResourceNodeMetadataAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GraphResourceNodeMetadata where parseJSON = checked "GraphResourceNodeMetadata" $ withObject "GraphResourceNodeMetadata" (\fields -> GraphResourceNodeMetadata <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON GraphResourceNodeMetadata where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (graphResourceNodeMetadataAdditionalProperties value)))

data GraphResourceNodeType = GraphResourceNodeTypeResource deriving (Eq, Show)

instance FromJSON GraphResourceNodeType where parseJSON = checked "GraphResourceNodeType" $ \value -> if value == String "resource" then pure GraphResourceNodeTypeResource else fail "unknown enumeration member"

instance ToJSON GraphResourceNodeType where toJSON GraphResourceNodeTypeResource = String "resource"

graphResourceNodeTypeText :: GraphResourceNodeType -> Text
graphResourceNodeTypeText GraphResourceNodeTypeResource = "resource"
