-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KnowledgeGraph (KnowledgeGraph (..), KnowledgeGraphEdgesItem (..), KnowledgeGraphNodesItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GraphAnnotationNode
import Xynolog.Internal.Generated.Models.GraphResourceNode

data KnowledgeGraph = KnowledgeGraph
  { knowledgeGraphNodes :: [KnowledgeGraphNodesItem],
    knowledgeGraphEdges :: [KnowledgeGraphEdgesItem],
    knowledgeGraphTruncated :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeGraph where parseJSON = checked "KnowledgeGraph" $ withObject "KnowledgeGraph" (\fields -> KnowledgeGraph <$> (fields .: "nodes") <*> (fields .: "edges") <*> optional fields "truncated")

instance ToJSON KnowledgeGraph where toJSON value = Object (KM.fromList (concat [[("nodes", toJSON (knowledgeGraphNodes value))], [("edges", toJSON (knowledgeGraphEdges value))], optionalPair "truncated" (knowledgeGraphTruncated value)]))

data KnowledgeGraphEdgesItem = KnowledgeGraphEdgesItem
  { knowledgeGraphEdgesItemSource :: Text,
    knowledgeGraphEdgesItemTarget :: Text,
    knowledgeGraphEdgesItemType :: Text,
    knowledgeGraphEdgesItemBidirectional :: Maybe Bool,
    knowledgeGraphEdgesItemMetadata :: Maybe (KM.KeyMap Value)
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeGraphEdgesItem where parseJSON = checked "KnowledgeGraphEdgesItem" $ withObject "KnowledgeGraphEdgesItem" (\fields -> KnowledgeGraphEdgesItem <$> (fields .: "source") <*> (fields .: "target") <*> (fields .: "type") <*> optional fields "bidirectional" <*> optional fields "metadata")

instance ToJSON KnowledgeGraphEdgesItem where toJSON value = Object (KM.fromList (concat [[("source", toJSON (knowledgeGraphEdgesItemSource value))], [("target", toJSON (knowledgeGraphEdgesItemTarget value))], [("type", toJSON (knowledgeGraphEdgesItemType value))], optionalPair "bidirectional" (knowledgeGraphEdgesItemBidirectional value), optionalPair "metadata" (knowledgeGraphEdgesItemMetadata value)]))

data KnowledgeGraphNodesItem = KnowledgeGraphNodesItemGraphResourceNode GraphResourceNode | KnowledgeGraphNodesItemGraphAnnotationNode GraphAnnotationNode deriving (Eq, Show)

instance FromJSON KnowledgeGraphNodesItem where parseJSON = checked "KnowledgeGraphNodesItem" $ \value -> readMember "KnowledgeGraphNodesItem" [([Signature {signatureKind = ObjectKind, signatureRequired = ["id", "type", "label"], signatureAllowed = Nothing, signatureFixed = [("type", [String "resource"])], signaturePattern = Nothing, signatureValues = Nothing}], KnowledgeGraphNodesItemGraphResourceNode <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["id", "type", "label", "annotation"], signatureAllowed = Nothing, signatureFixed = [("type", [String "annotation"])], signaturePattern = Nothing, signatureValues = Nothing}], KnowledgeGraphNodesItemGraphAnnotationNode <$> parseJSON value)] value

instance ToJSON KnowledgeGraphNodesItem where
  toJSON (KnowledgeGraphNodesItemGraphResourceNode value) = toJSON value
  toJSON (KnowledgeGraphNodesItemGraphAnnotationNode value) = toJSON value
