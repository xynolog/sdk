-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GraphAnnotationNode (GraphAnnotationNode (..), GraphAnnotationNodeType (..), graphAnnotationNodeTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Annotation
import Xynolog.Internal.Generated.Models.AnnotationId

data GraphAnnotationNode = GraphAnnotationNode
  { graphAnnotationNodeId :: AnnotationId,
    graphAnnotationNodeType :: GraphAnnotationNodeType,
    graphAnnotationNodeLabel :: Text,
    graphAnnotationNodeEntityTypes :: Maybe [Text],
    graphAnnotationNodeAnnotation :: Annotation,
    graphAnnotationNodeMetadata :: Maybe (KM.KeyMap Value)
  }
  deriving (Eq, Show)

instance FromJSON GraphAnnotationNode where parseJSON = checked "GraphAnnotationNode" $ withObject "GraphAnnotationNode" (\fields -> GraphAnnotationNode <$> (fields .: "id") <*> (fields .: "type") <*> (fields .: "label") <*> optional fields "entityTypes" <*> (fields .: "annotation") <*> optional fields "metadata")

instance ToJSON GraphAnnotationNode where toJSON value = Object (KM.fromList (concat [[("id", toJSON (graphAnnotationNodeId value))], [("type", toJSON (graphAnnotationNodeType value))], [("label", toJSON (graphAnnotationNodeLabel value))], optionalPair "entityTypes" (graphAnnotationNodeEntityTypes value), [("annotation", toJSON (graphAnnotationNodeAnnotation value))], optionalPair "metadata" (graphAnnotationNodeMetadata value)]))

data GraphAnnotationNodeType = GraphAnnotationNodeTypeAnnotation deriving (Eq, Show)

instance FromJSON GraphAnnotationNodeType where parseJSON = checked "GraphAnnotationNodeType" $ \value -> if value == String "annotation" then pure GraphAnnotationNodeTypeAnnotation else fail "unknown enumeration member"

instance ToJSON GraphAnnotationNodeType where toJSON GraphAnnotationNodeTypeAnnotation = String "annotation"

graphAnnotationNodeTypeText :: GraphAnnotationNodeType -> Text
graphAnnotationNodeTypeText GraphAnnotationNodeTypeAnnotation = "annotation"
