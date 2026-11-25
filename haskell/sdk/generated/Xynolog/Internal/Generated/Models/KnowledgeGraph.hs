-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KnowledgeGraph (KnowledgeGraph (..), KnowledgeGraphEdgesItem (..), KnowledgeGraphEdgesItemMetadata (..), KnowledgeGraphNodesItem (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GraphAnnotationNode
import Xynolog.Internal.Generated.Models.GraphResourceNode

data KnowledgeGraph = KnowledgeGraph
  { knowledgeGraphEdges :: [KnowledgeGraphEdgesItem],
    knowledgeGraphNodes :: [KnowledgeGraphNodesItem],
    knowledgeGraphTruncated :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeGraph where parseJSON = checked "KnowledgeGraph" $ withObject "KnowledgeGraph" (\fields -> KnowledgeGraph <$> (fields .: "edges") <*> (fields .: "nodes") <*> optional fields "truncated")

instance ToJSON KnowledgeGraph where toJSON value = Object (KM.fromList (concat [[("edges", toJSON (knowledgeGraphEdges value))], [("nodes", toJSON (knowledgeGraphNodes value))], optionalPair "truncated" (knowledgeGraphTruncated value)]))

data KnowledgeGraphEdgesItem = KnowledgeGraphEdgesItem
  { knowledgeGraphEdgesItemBidirectional :: Maybe Bool,
    knowledgeGraphEdgesItemMetadata :: Maybe KnowledgeGraphEdgesItemMetadata,
    knowledgeGraphEdgesItemSource :: Text,
    knowledgeGraphEdgesItemTarget :: Text,
    knowledgeGraphEdgesItemType :: Text
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeGraphEdgesItem where parseJSON = checked "KnowledgeGraphEdgesItem" $ withObject "KnowledgeGraphEdgesItem" (\fields -> KnowledgeGraphEdgesItem <$> optional fields "bidirectional" <*> optional fields "metadata" <*> (fields .: "source") <*> (fields .: "target") <*> (fields .: "type"))

instance ToJSON KnowledgeGraphEdgesItem where toJSON value = Object (KM.fromList (concat [optionalPair "bidirectional" (knowledgeGraphEdgesItemBidirectional value), optionalPair "metadata" (knowledgeGraphEdgesItemMetadata value), [("source", toJSON (knowledgeGraphEdgesItemSource value))], [("target", toJSON (knowledgeGraphEdgesItemTarget value))], [("type", toJSON (knowledgeGraphEdgesItemType value))]]))

data KnowledgeGraphEdgesItemMetadata = KnowledgeGraphEdgesItemMetadata
  { knowledgeGraphEdgesItemMetadataAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeGraphEdgesItemMetadata where parseJSON = checked "KnowledgeGraphEdgesItemMetadata" $ withObject "KnowledgeGraphEdgesItemMetadata" (\fields -> KnowledgeGraphEdgesItemMetadata <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON KnowledgeGraphEdgesItemMetadata where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (knowledgeGraphEdgesItemMetadataAdditionalProperties value)))

data KnowledgeGraphNodesItem = KnowledgeGraphNodesItemGraphResourceNode GraphResourceNode | KnowledgeGraphNodesItemGraphAnnotationNode GraphAnnotationNode deriving (Eq, Show)

instance FromJSON KnowledgeGraphNodesItem where parseJSON = checked "KnowledgeGraphNodesItem" $ \value -> (KnowledgeGraphNodesItemGraphResourceNode <$> parseJSON value) <|> (KnowledgeGraphNodesItemGraphAnnotationNode <$> parseJSON value)

instance ToJSON KnowledgeGraphNodesItem where
  toJSON (KnowledgeGraphNodesItemGraphResourceNode value) = toJSON value
  toJSON (KnowledgeGraphNodesItemGraphAnnotationNode value) = toJSON value
