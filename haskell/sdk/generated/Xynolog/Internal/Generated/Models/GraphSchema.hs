-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GraphSchema (GraphSchema (..), GraphSchemaNodes (..), GraphSchemaNodesAnnotation (..), GraphSchemaNodesEntityType (..), GraphSchemaNodesResource (..), GraphSchemaRelationships (..), GraphSchemaRelationshipsBelongsTo (..), GraphSchemaRelationshipsReferences (..), GraphSchemaRelationshipsTaggedAs (..), GraphSchemaStub (..)) where

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
  { graphSchemaNodesAnnotation :: GraphSchemaNodesAnnotation,
    graphSchemaNodesEntityType :: GraphSchemaNodesEntityType,
    graphSchemaNodesResource :: GraphSchemaNodesResource
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaNodes where parseJSON = checked "GraphSchemaNodes" $ withObject "GraphSchemaNodes" (\fields -> GraphSchemaNodes <$> (fields .: "annotation") <*> (fields .: "entityType") <*> (fields .: "resource"))

instance ToJSON GraphSchemaNodes where toJSON value = Object (KM.fromList (concat [[("annotation", toJSON (graphSchemaNodesAnnotation value))], [("entityType", toJSON (graphSchemaNodesEntityType value))], [("resource", toJSON (graphSchemaNodesResource value))]]))

data GraphSchemaNodesAnnotation = GraphSchemaNodesAnnotation
  { graphSchemaNodesAnnotationKey :: Text,
    graphSchemaNodesAnnotationLabel :: Text,
    graphSchemaNodesAnnotationLookups :: [Text],
    graphSchemaNodesAnnotationRow :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaNodesAnnotation where parseJSON = checked "GraphSchemaNodesAnnotation" $ withObject "GraphSchemaNodesAnnotation" (\fields -> GraphSchemaNodesAnnotation <$> (fields .: "key") <*> (fields .: "label") <*> (fields .: "lookups") <*> optional fields "row")

instance ToJSON GraphSchemaNodesAnnotation where toJSON value = Object (KM.fromList (concat [[("key", toJSON (graphSchemaNodesAnnotationKey value))], [("label", toJSON (graphSchemaNodesAnnotationLabel value))], [("lookups", toJSON (graphSchemaNodesAnnotationLookups value))], optionalPair "row" (graphSchemaNodesAnnotationRow value)]))

data GraphSchemaNodesEntityType = GraphSchemaNodesEntityType
  { graphSchemaNodesEntityTypeKey :: Text,
    graphSchemaNodesEntityTypeLabel :: Text,
    graphSchemaNodesEntityTypeLookups :: [Text],
    graphSchemaNodesEntityTypeRow :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaNodesEntityType where parseJSON = checked "GraphSchemaNodesEntityType" $ withObject "GraphSchemaNodesEntityType" (\fields -> GraphSchemaNodesEntityType <$> (fields .: "key") <*> (fields .: "label") <*> (fields .: "lookups") <*> optional fields "row")

instance ToJSON GraphSchemaNodesEntityType where toJSON value = Object (KM.fromList (concat [[("key", toJSON (graphSchemaNodesEntityTypeKey value))], [("label", toJSON (graphSchemaNodesEntityTypeLabel value))], [("lookups", toJSON (graphSchemaNodesEntityTypeLookups value))], optionalPair "row" (graphSchemaNodesEntityTypeRow value)]))

data GraphSchemaNodesResource = GraphSchemaNodesResource
  { graphSchemaNodesResourceKey :: Text,
    graphSchemaNodesResourceLabel :: Text,
    graphSchemaNodesResourceLookups :: [Text],
    graphSchemaNodesResourceRow :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaNodesResource where parseJSON = checked "GraphSchemaNodesResource" $ withObject "GraphSchemaNodesResource" (\fields -> GraphSchemaNodesResource <$> (fields .: "key") <*> (fields .: "label") <*> (fields .: "lookups") <*> optional fields "row")

instance ToJSON GraphSchemaNodesResource where toJSON value = Object (KM.fromList (concat [[("key", toJSON (graphSchemaNodesResourceKey value))], [("label", toJSON (graphSchemaNodesResourceLabel value))], [("lookups", toJSON (graphSchemaNodesResourceLookups value))], optionalPair "row" (graphSchemaNodesResourceRow value)]))

data GraphSchemaRelationships = GraphSchemaRelationships
  { graphSchemaRelationshipsBelongsTo :: GraphSchemaRelationshipsBelongsTo,
    graphSchemaRelationshipsReferences :: GraphSchemaRelationshipsReferences,
    graphSchemaRelationshipsTaggedAs :: GraphSchemaRelationshipsTaggedAs
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaRelationships where parseJSON = checked "GraphSchemaRelationships" $ withObject "GraphSchemaRelationships" (\fields -> GraphSchemaRelationships <$> (fields .: "belongsTo") <*> (fields .: "references") <*> (fields .: "taggedAs"))

instance ToJSON GraphSchemaRelationships where toJSON value = Object (KM.fromList (concat [[("belongsTo", toJSON (graphSchemaRelationshipsBelongsTo value))], [("references", toJSON (graphSchemaRelationshipsReferences value))], [("taggedAs", toJSON (graphSchemaRelationshipsTaggedAs value))]]))

data GraphSchemaRelationshipsBelongsTo = GraphSchemaRelationshipsBelongsTo
  { graphSchemaRelationshipsBelongsToFrom :: Text,
    graphSchemaRelationshipsBelongsToSays :: Text,
    graphSchemaRelationshipsBelongsToTo :: Text,
    graphSchemaRelationshipsBelongsToType :: Text
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaRelationshipsBelongsTo where parseJSON = checked "GraphSchemaRelationshipsBelongsTo" $ withObject "GraphSchemaRelationshipsBelongsTo" (\fields -> GraphSchemaRelationshipsBelongsTo <$> (fields .: "from") <*> (fields .: "says") <*> (fields .: "to") <*> (fields .: "type"))

instance ToJSON GraphSchemaRelationshipsBelongsTo where toJSON value = Object (KM.fromList (concat [[("from", toJSON (graphSchemaRelationshipsBelongsToFrom value))], [("says", toJSON (graphSchemaRelationshipsBelongsToSays value))], [("to", toJSON (graphSchemaRelationshipsBelongsToTo value))], [("type", toJSON (graphSchemaRelationshipsBelongsToType value))]]))

data GraphSchemaRelationshipsReferences = GraphSchemaRelationshipsReferences
  { graphSchemaRelationshipsReferencesFrom :: Text,
    graphSchemaRelationshipsReferencesSays :: Text,
    graphSchemaRelationshipsReferencesTo :: Text,
    graphSchemaRelationshipsReferencesType :: Text
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaRelationshipsReferences where parseJSON = checked "GraphSchemaRelationshipsReferences" $ withObject "GraphSchemaRelationshipsReferences" (\fields -> GraphSchemaRelationshipsReferences <$> (fields .: "from") <*> (fields .: "says") <*> (fields .: "to") <*> (fields .: "type"))

instance ToJSON GraphSchemaRelationshipsReferences where toJSON value = Object (KM.fromList (concat [[("from", toJSON (graphSchemaRelationshipsReferencesFrom value))], [("says", toJSON (graphSchemaRelationshipsReferencesSays value))], [("to", toJSON (graphSchemaRelationshipsReferencesTo value))], [("type", toJSON (graphSchemaRelationshipsReferencesType value))]]))

data GraphSchemaRelationshipsTaggedAs = GraphSchemaRelationshipsTaggedAs
  { graphSchemaRelationshipsTaggedAsFrom :: Text,
    graphSchemaRelationshipsTaggedAsSays :: Text,
    graphSchemaRelationshipsTaggedAsTo :: Text,
    graphSchemaRelationshipsTaggedAsType :: Text
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaRelationshipsTaggedAs where parseJSON = checked "GraphSchemaRelationshipsTaggedAs" $ withObject "GraphSchemaRelationshipsTaggedAs" (\fields -> GraphSchemaRelationshipsTaggedAs <$> (fields .: "from") <*> (fields .: "says") <*> (fields .: "to") <*> (fields .: "type"))

instance ToJSON GraphSchemaRelationshipsTaggedAs where toJSON value = Object (KM.fromList (concat [[("from", toJSON (graphSchemaRelationshipsTaggedAsFrom value))], [("says", toJSON (graphSchemaRelationshipsTaggedAsSays value))], [("to", toJSON (graphSchemaRelationshipsTaggedAsTo value))], [("type", toJSON (graphSchemaRelationshipsTaggedAsType value))]]))

data GraphSchemaStub = GraphSchemaStub
  { graphSchemaStubMarker :: Text,
    graphSchemaStubNode :: Text
  }
  deriving (Eq, Show)

instance FromJSON GraphSchemaStub where parseJSON = checked "GraphSchemaStub" $ withObject "GraphSchemaStub" (\fields -> GraphSchemaStub <$> (fields .: "marker") <*> (fields .: "node"))

instance ToJSON GraphSchemaStub where toJSON value = Object (KM.fromList (concat [[("marker", toJSON (graphSchemaStubMarker value))], [("node", toJSON (graphSchemaStubNode value))]]))
