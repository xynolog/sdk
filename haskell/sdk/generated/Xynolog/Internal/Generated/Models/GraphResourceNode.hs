-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GraphResourceNode (GraphResourceNode (..), GraphResourceNodeType (..), graphResourceNodeTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data GraphResourceNode = GraphResourceNode
  { graphResourceNodeId :: ResourceId,
    graphResourceNodeType :: GraphResourceNodeType,
    graphResourceNodeLabel :: Text,
    graphResourceNodeEntityTypes :: Maybe [Text],
    graphResourceNodeMetadata :: Maybe (KM.KeyMap Value)
  }
  deriving (Eq, Show)

instance FromJSON GraphResourceNode where parseJSON = checked "GraphResourceNode" $ withObject "GraphResourceNode" (\fields -> GraphResourceNode <$> (fields .: "id") <*> (fields .: "type") <*> (fields .: "label") <*> optional fields "entityTypes" <*> optional fields "metadata")

instance ToJSON GraphResourceNode where toJSON value = Object (KM.fromList (concat [[("id", toJSON (graphResourceNodeId value))], [("type", toJSON (graphResourceNodeType value))], [("label", toJSON (graphResourceNodeLabel value))], optionalPair "entityTypes" (graphResourceNodeEntityTypes value), optionalPair "metadata" (graphResourceNodeMetadata value)]))

data GraphResourceNodeType = GraphResourceNodeTypeResource deriving (Eq, Show)

instance FromJSON GraphResourceNodeType where parseJSON = checked "GraphResourceNodeType" $ \value -> if value == String "resource" then pure GraphResourceNodeTypeResource else fail "unknown enumeration member"

instance ToJSON GraphResourceNodeType where toJSON GraphResourceNodeTypeResource = String "resource"

graphResourceNodeTypeText :: GraphResourceNodeType -> Text
graphResourceNodeTypeText GraphResourceNodeTypeResource = "resource"
