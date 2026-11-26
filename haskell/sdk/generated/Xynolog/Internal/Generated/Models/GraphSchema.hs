-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GraphSchema (GraphSchema (..), GraphSchemaNodes (..), GraphSchemaNodesResource (..), GraphSchemaRelationships (..), GraphSchemaRelationshipsBelongsTo (..), GraphSchemaStub (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data GraphSchema = GraphSchema
  { graphSchemaComment :: Text,
    graphSchemaNodes :: GraphSchemaNodes,
    graphSchemaRelationships :: GraphSchemaRelationships,
    graphSchemaStub :: GraphSchemaStub
  }
  deriving (Eq, Show)

instance FromJSON GraphSchema where parseJSON = checked "GraphSchema" $ withObject "GraphSchema" (\fields -> GraphSchema <$> (fields .: "$comment") <*> (fields .: "nodes") <*> (fields .: "relationships") <*> (fields .: "stub"))

instance ToJSON GraphSchema where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (graphSchemaComment value))], [("nodes", toJSON (graphSchemaNodes value))], [("relationships", toJSON (graphSchemaRelationships value))], [("stub", toJSON (graphSchemaStub value))]]))

data GraphSchemaNodes = GraphSchemaNodes
  { graphSchemaNodesResource :: GraphSchemaNodesResource,
    graphSchemaNodesAnnotation :: GraphSchemaNodesResource,
    graphSchemaNodesEntityType :: GraphSchemaNodesResource
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaNodes where parseJSON = checked "GraphSchemaNodes" $ withObject "GraphSchemaNodes" (\fields -> GraphSchemaNodes <$> (fields .: "resource") <*> (fields .: "annotation") <*> (fields .: "entityType"))

instance ToJSON GraphSchemaNodes where toJSON value = Object (KM.fromList (concat [[("resource", toJSON (graphSchemaNodesResource value))], [("annotation", toJSON (graphSchemaNodesAnnotation value))], [("entityType", toJSON (graphSchemaNodesEntityType value))]]))

data GraphSchemaNodesResource = GraphSchemaNodesResource
  { graphSchemaNodesResourceLabel :: Text,
    graphSchemaNodesResourceRow :: Maybe Text,
    graphSchemaNodesResourceKey :: Text,
    graphSchemaNodesResourceLookups :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaNodesResource where parseJSON = checked "GraphSchemaNodesResource" $ withObject "GraphSchemaNodesResource" (\fields -> GraphSchemaNodesResource <$> (fields .: "label") <*> optional fields "row" <*> (fields .: "key") <*> (fields .: "lookups"))

instance ToJSON GraphSchemaNodesResource where toJSON value = Object (KM.fromList (concat [[("label", toJSON (graphSchemaNodesResourceLabel value))], optionalPair "row" (graphSchemaNodesResourceRow value), [("key", toJSON (graphSchemaNodesResourceKey value))], [("lookups", toJSON (graphSchemaNodesResourceLookups value))]]))

data GraphSchemaRelationships = GraphSchemaRelationships
  { graphSchemaRelationshipsBelongsTo :: GraphSchemaRelationshipsBelongsTo,
    graphSchemaRelationshipsReferences :: GraphSchemaRelationshipsBelongsTo,
    graphSchemaRelationshipsTaggedAs :: GraphSchemaRelationshipsBelongsTo
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaRelationships where parseJSON = checked "GraphSchemaRelationships" $ withObject "GraphSchemaRelationships" (\fields -> GraphSchemaRelationships <$> (fields .: "belongsTo") <*> (fields .: "references") <*> (fields .: "taggedAs"))

instance ToJSON GraphSchemaRelationships where toJSON value = Object (KM.fromList (concat [[("belongsTo", toJSON (graphSchemaRelationshipsBelongsTo value))], [("references", toJSON (graphSchemaRelationshipsReferences value))], [("taggedAs", toJSON (graphSchemaRelationshipsTaggedAs value))]]))

data GraphSchemaRelationshipsBelongsTo = GraphSchemaRelationshipsBelongsTo
  { graphSchemaRelationshipsBelongsToType :: Text,
    graphSchemaRelationshipsBelongsToFrom :: Text,
    graphSchemaRelationshipsBelongsToTo :: Text,
    graphSchemaRelationshipsBelongsToSays :: Text
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaRelationshipsBelongsTo where parseJSON = checked "GraphSchemaRelationshipsBelongsTo" $ withObject "GraphSchemaRelationshipsBelongsTo" (\fields -> GraphSchemaRelationshipsBelongsTo <$> (fields .: "type") <*> (fields .: "from") <*> (fields .: "to") <*> (fields .: "says"))

instance ToJSON GraphSchemaRelationshipsBelongsTo where toJSON value = Object (KM.fromList (concat [[("type", toJSON (graphSchemaRelationshipsBelongsToType value))], [("from", toJSON (graphSchemaRelationshipsBelongsToFrom value))], [("to", toJSON (graphSchemaRelationshipsBelongsToTo value))], [("says", toJSON (graphSchemaRelationshipsBelongsToSays value))]]))

data GraphSchemaStub = GraphSchemaStub
  { graphSchemaStubNode :: Text,
    graphSchemaStubMarker :: Text
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaStub where parseJSON = checked "GraphSchemaStub" $ withObject "GraphSchemaStub" (\fields -> GraphSchemaStub <$> (fields .: "node") <*> (fields .: "marker"))

instance ToJSON GraphSchemaStub where toJSON value = Object (KM.fromList (concat [[("node", toJSON (graphSchemaStubNode value))], [("marker", toJSON (graphSchemaStubMarker value))]]))
