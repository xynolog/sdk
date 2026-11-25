-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GraphAnnotationNode (GraphAnnotationNode (..), GraphAnnotationNodeMetadata (..), GraphAnnotationNodeType (..), graphAnnotationNodeTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Annotation
import Xynolog.Internal.Generated.Models.AnnotationId

data GraphAnnotationNode = GraphAnnotationNode
  { graphAnnotationNodeAnnotation :: Annotation,
    graphAnnotationNodeEntityTypes :: Maybe [Text],
    graphAnnotationNodeId :: AnnotationId,
    graphAnnotationNodeLabel :: Text,
    graphAnnotationNodeMetadata :: Maybe GraphAnnotationNodeMetadata,
    graphAnnotationNodeType :: GraphAnnotationNodeType
  }
  deriving (Eq, Show)

instance FromJSON GraphAnnotationNode where parseJSON = checked "GraphAnnotationNode" $ withObject "GraphAnnotationNode" (\fields -> GraphAnnotationNode <$> (fields .: "annotation") <*> optional fields "entityTypes" <*> (fields .: "id") <*> (fields .: "label") <*> optional fields "metadata" <*> (fields .: "type"))

instance ToJSON GraphAnnotationNode where toJSON value = Object (KM.fromList (concat [[("annotation", toJSON (graphAnnotationNodeAnnotation value))], optionalPair "entityTypes" (graphAnnotationNodeEntityTypes value), [("id", toJSON (graphAnnotationNodeId value))], [("label", toJSON (graphAnnotationNodeLabel value))], optionalPair "metadata" (graphAnnotationNodeMetadata value), [("type", toJSON (graphAnnotationNodeType value))]]))

data GraphAnnotationNodeMetadata = GraphAnnotationNodeMetadata
  { graphAnnotationNodeMetadataAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GraphAnnotationNodeMetadata where parseJSON = checked "GraphAnnotationNodeMetadata" $ withObject "GraphAnnotationNodeMetadata" (\fields -> GraphAnnotationNodeMetadata <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON GraphAnnotationNodeMetadata where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (graphAnnotationNodeMetadataAdditionalProperties value)))

data GraphAnnotationNodeType = GraphAnnotationNodeTypeAnnotation deriving (Eq, Show)

instance FromJSON GraphAnnotationNodeType where parseJSON = checked "GraphAnnotationNodeType" $ \value -> if value == String "annotation" then pure GraphAnnotationNodeTypeAnnotation else fail "unknown enumeration member"

instance ToJSON GraphAnnotationNodeType where toJSON GraphAnnotationNodeTypeAnnotation = String "annotation"

graphAnnotationNodeTypeText :: GraphAnnotationNodeType -> Text
graphAnnotationNodeTypeText GraphAnnotationNodeTypeAnnotation = "annotation"
