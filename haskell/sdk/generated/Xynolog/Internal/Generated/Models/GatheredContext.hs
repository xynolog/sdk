-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatheredContext (GatheredContext (..), GatheredContextFocus (..), GatheredContextFocusAnnotation (..), GatheredContextFocusAnnotationKind (..), gatheredContextFocusAnnotationKindText, GatheredContextFocusAnnotationSelected (..), GatheredContextFocusAnnotationTargetContext (..), GatheredContextFocusResource (..), GatheredContextFocusResourceContent (..), GatheredContextFocusResourceContentRelated (..), GatheredContextFocusResourceKind (..), gatheredContextFocusResourceKindText, GatheredContextMetadata (..), GatheredContextMetadataEntityTypeFrequencies (..), GatheredContextSemanticContext (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Annotation
import Xynolog.Internal.Generated.Models.KnowledgeGraph
import Xynolog.Internal.Generated.Models.ResourceDescriptor
import Xynolog.Internal.Generated.Models.SemanticMatch

data GatheredContext = GatheredContext
  { gatheredContextFocus :: GatheredContextFocus,
    gatheredContextGraph :: KnowledgeGraph,
    gatheredContextInferredRelationshipSummary :: Maybe Text,
    gatheredContextMetadata :: GatheredContextMetadata,
    gatheredContextSemanticContext :: Maybe GatheredContextSemanticContext
  }
  deriving (Eq, Show)

instance FromJSON GatheredContext where parseJSON = checked "GatheredContext" $ withObject "GatheredContext" (\fields -> GatheredContext <$> (fields .: "focus") <*> (fields .: "graph") <*> optional fields "inferredRelationshipSummary" <*> (fields .: "metadata") <*> optional fields "semanticContext")

instance ToJSON GatheredContext where toJSON value = Object (KM.fromList (concat [[("focus", toJSON (gatheredContextFocus value))], [("graph", toJSON (gatheredContextGraph value))], optionalPair "inferredRelationshipSummary" (gatheredContextInferredRelationshipSummary value), [("metadata", toJSON (gatheredContextMetadata value))], optionalPair "semanticContext" (gatheredContextSemanticContext value)]))

data GatheredContextFocus = GatheredContextFocusAnnotation GatheredContextFocusAnnotation | GatheredContextFocusResource GatheredContextFocusResource deriving (Eq, Show)

instance FromJSON GatheredContextFocus where parseJSON = checked "GatheredContextFocus" $ \value -> (GatheredContextFocusAnnotation <$> parseJSON value) <|> (GatheredContextFocusResource <$> parseJSON value)

instance ToJSON GatheredContextFocus where
  toJSON (GatheredContextFocusAnnotation value) = toJSON value
  toJSON (GatheredContextFocusResource value) = toJSON value

data GatheredContextFocusAnnotation = MkGatheredContextFocusAnnotation
  { gatheredContextFocusAnnotationAnnotation :: Annotation,
    gatheredContextFocusAnnotationKind :: GatheredContextFocusAnnotationKind,
    gatheredContextFocusAnnotationSelected :: Maybe GatheredContextFocusAnnotationSelected,
    gatheredContextFocusAnnotationSourceResource :: ResourceDescriptor,
    gatheredContextFocusAnnotationTargetContext :: Maybe GatheredContextFocusAnnotationTargetContext,
    gatheredContextFocusAnnotationTargetResource :: Maybe ResourceDescriptor,
    gatheredContextFocusAnnotationUserHint :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotation where parseJSON = checked "GatheredContextFocusAnnotation" $ withObject "GatheredContextFocusAnnotation" (\fields -> MkGatheredContextFocusAnnotation <$> (fields .: "annotation") <*> (fields .: "kind") <*> optional fields "selected" <*> (fields .: "sourceResource") <*> optional fields "targetContext" <*> optional fields "targetResource" <*> optional fields "userHint")

instance ToJSON GatheredContextFocusAnnotation where toJSON value = Object (KM.fromList (concat [[("annotation", toJSON (gatheredContextFocusAnnotationAnnotation value))], [("kind", toJSON (gatheredContextFocusAnnotationKind value))], optionalPair "selected" (gatheredContextFocusAnnotationSelected value), [("sourceResource", toJSON (gatheredContextFocusAnnotationSourceResource value))], optionalPair "targetContext" (gatheredContextFocusAnnotationTargetContext value), optionalPair "targetResource" (gatheredContextFocusAnnotationTargetResource value), optionalPair "userHint" (gatheredContextFocusAnnotationUserHint value)]))

data GatheredContextFocusAnnotationKind = GatheredContextFocusAnnotationKindAnnotation deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotationKind where parseJSON = checked "GatheredContextFocusAnnotationKind" $ \value -> if value == String "annotation" then pure GatheredContextFocusAnnotationKindAnnotation else fail "unknown enumeration member"

instance ToJSON GatheredContextFocusAnnotationKind where toJSON GatheredContextFocusAnnotationKindAnnotation = String "annotation"

gatheredContextFocusAnnotationKindText :: GatheredContextFocusAnnotationKind -> Text
gatheredContextFocusAnnotationKindText GatheredContextFocusAnnotationKindAnnotation = "annotation"

data GatheredContextFocusAnnotationSelected = GatheredContextFocusAnnotationSelected
  { gatheredContextFocusAnnotationSelectedAfter :: Maybe Text,
    gatheredContextFocusAnnotationSelectedBefore :: Maybe Text,
    gatheredContextFocusAnnotationSelectedText :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotationSelected where parseJSON = checked "GatheredContextFocusAnnotationSelected" $ withObject "GatheredContextFocusAnnotationSelected" (\fields -> GatheredContextFocusAnnotationSelected <$> optional fields "after" <*> optional fields "before" <*> (fields .: "text"))

instance ToJSON GatheredContextFocusAnnotationSelected where toJSON value = Object (KM.fromList (concat [optionalPair "after" (gatheredContextFocusAnnotationSelectedAfter value), optionalPair "before" (gatheredContextFocusAnnotationSelectedBefore value), [("text", toJSON (gatheredContextFocusAnnotationSelectedText value))]]))

data GatheredContextFocusAnnotationTargetContext = GatheredContextFocusAnnotationTargetContext
  { gatheredContextFocusAnnotationTargetContextContent :: Text,
    gatheredContextFocusAnnotationTargetContextSummary :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotationTargetContext where parseJSON = checked "GatheredContextFocusAnnotationTargetContext" $ withObject "GatheredContextFocusAnnotationTargetContext" (\fields -> GatheredContextFocusAnnotationTargetContext <$> (fields .: "content") <*> optional fields "summary")

instance ToJSON GatheredContextFocusAnnotationTargetContext where toJSON value = Object (KM.fromList (concat [[("content", toJSON (gatheredContextFocusAnnotationTargetContextContent value))], optionalPair "summary" (gatheredContextFocusAnnotationTargetContextSummary value)]))

data GatheredContextFocusResource = MkGatheredContextFocusResource
  { gatheredContextFocusResourceContent :: Maybe GatheredContextFocusResourceContent,
    gatheredContextFocusResourceKind :: GatheredContextFocusResourceKind,
    gatheredContextFocusResourceResource :: ResourceDescriptor,
    gatheredContextFocusResourceSuggestedReferences :: Maybe [Text],
    gatheredContextFocusResourceSummary :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusResource where parseJSON = checked "GatheredContextFocusResource" $ withObject "GatheredContextFocusResource" (\fields -> MkGatheredContextFocusResource <$> optional fields "content" <*> (fields .: "kind") <*> (fields .: "resource") <*> optional fields "suggestedReferences" <*> optional fields "summary")

instance ToJSON GatheredContextFocusResource where toJSON value = Object (KM.fromList (concat [optionalPair "content" (gatheredContextFocusResourceContent value), [("kind", toJSON (gatheredContextFocusResourceKind value))], [("resource", toJSON (gatheredContextFocusResourceResource value))], optionalPair "suggestedReferences" (gatheredContextFocusResourceSuggestedReferences value), optionalPair "summary" (gatheredContextFocusResourceSummary value)]))

data GatheredContextFocusResourceContent = GatheredContextFocusResourceContent
  { gatheredContextFocusResourceContentMain :: Maybe Text,
    gatheredContextFocusResourceContentRelated :: Maybe GatheredContextFocusResourceContentRelated
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusResourceContent where parseJSON = checked "GatheredContextFocusResourceContent" $ withObject "GatheredContextFocusResourceContent" (\fields -> GatheredContextFocusResourceContent <$> optional fields "main" <*> optional fields "related")

instance ToJSON GatheredContextFocusResourceContent where toJSON value = Object (KM.fromList (concat [optionalPair "main" (gatheredContextFocusResourceContentMain value), optionalPair "related" (gatheredContextFocusResourceContentRelated value)]))

data GatheredContextFocusResourceContentRelated = GatheredContextFocusResourceContentRelated
  { gatheredContextFocusResourceContentRelatedAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusResourceContentRelated where parseJSON = checked "GatheredContextFocusResourceContentRelated" $ withObject "GatheredContextFocusResourceContentRelated" (\fields -> GatheredContextFocusResourceContentRelated <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON GatheredContextFocusResourceContentRelated where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (gatheredContextFocusResourceContentRelatedAdditionalProperties value)))

data GatheredContextFocusResourceKind = GatheredContextFocusResourceKindResource deriving (Eq, Show)

instance FromJSON GatheredContextFocusResourceKind where parseJSON = checked "GatheredContextFocusResourceKind" $ \value -> if value == String "resource" then pure GatheredContextFocusResourceKindResource else fail "unknown enumeration member"

instance ToJSON GatheredContextFocusResourceKind where toJSON GatheredContextFocusResourceKindResource = String "resource"

gatheredContextFocusResourceKindText :: GatheredContextFocusResourceKind -> Text
gatheredContextFocusResourceKindText GatheredContextFocusResourceKindResource = "resource"

data GatheredContextMetadata = GatheredContextMetadata
  { gatheredContextMetadataEntityTypeFrequencies :: Maybe GatheredContextMetadataEntityTypeFrequencies,
    gatheredContextMetadataEntityTypes :: Maybe [Text],
    gatheredContextMetadataLanguage :: Maybe Text,
    gatheredContextMetadataResourceType :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextMetadata where parseJSON = checked "GatheredContextMetadata" $ withObject "GatheredContextMetadata" (\fields -> GatheredContextMetadata <$> optional fields "entityTypeFrequencies" <*> optional fields "entityTypes" <*> optional fields "language" <*> optional fields "resourceType")

instance ToJSON GatheredContextMetadata where toJSON value = Object (KM.fromList (concat [optionalPair "entityTypeFrequencies" (gatheredContextMetadataEntityTypeFrequencies value), optionalPair "entityTypes" (gatheredContextMetadataEntityTypes value), optionalPair "language" (gatheredContextMetadataLanguage value), optionalPair "resourceType" (gatheredContextMetadataResourceType value)]))

data GatheredContextMetadataEntityTypeFrequencies = GatheredContextMetadataEntityTypeFrequencies
  { gatheredContextMetadataEntityTypeFrequenciesAdditionalProperties :: KM.KeyMap Integer
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextMetadataEntityTypeFrequencies where parseJSON = checked "GatheredContextMetadataEntityTypeFrequencies" $ withObject "GatheredContextMetadataEntityTypeFrequencies" (\fields -> GatheredContextMetadataEntityTypeFrequencies <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON GatheredContextMetadataEntityTypeFrequencies where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (gatheredContextMetadataEntityTypeFrequenciesAdditionalProperties value)))

data GatheredContextSemanticContext = GatheredContextSemanticContext
  { gatheredContextSemanticContextExcludedEntityTypes :: Maybe [Text],
    gatheredContextSemanticContextSimilar :: [SemanticMatch]
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextSemanticContext where parseJSON = checked "GatheredContextSemanticContext" $ withObject "GatheredContextSemanticContext" (\fields -> GatheredContextSemanticContext <$> optional fields "excludedEntityTypes" <*> (fields .: "similar"))

instance ToJSON GatheredContextSemanticContext where toJSON value = Object (KM.fromList (concat [optionalPair "excludedEntityTypes" (gatheredContextSemanticContextExcludedEntityTypes value), [("similar", toJSON (gatheredContextSemanticContextSimilar value))]]))
