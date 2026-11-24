-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatheredContext (GatheredContext (..), GatheredContextFocus (..), GatheredContextFocusAnnotationValue (..), GatheredContextFocusAnnotationValueKind (..), gatheredContextFocusAnnotationValueKindText, GatheredContextFocusAnnotationValueSelected (..), GatheredContextFocusAnnotationValueTargetContext (..), GatheredContextFocusResourceValue (..), GatheredContextFocusResourceValueContent (..), GatheredContextFocusResourceValueContentRelated (..), GatheredContextFocusResourceValueKind (..), gatheredContextFocusResourceValueKindText, GatheredContextMetadata (..), GatheredContextMetadataEntityTypeFrequencies (..), GatheredContextSemanticContext (..)) where

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
    gatheredContextSemanticContext :: Maybe GatheredContextSemanticContext,
    gatheredContextAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GatheredContext where parseJSON = checked "GatheredContext" $ withObject "GatheredContext" (\fields -> GatheredContext <$> (fields .: "focus") <*> (fields .: "graph") <*> optional fields "inferredRelationshipSummary" <*> (fields .: "metadata") <*> optional fields "semanticContext" <*> traverse parseJSON (withoutFields ["focus", "graph", "inferredRelationshipSummary", "metadata", "semanticContext"] fields))

instance ToJSON GatheredContext where toJSON value = Object (KM.fromList (concat [[("focus", toJSON (gatheredContextFocus value))], [("graph", toJSON (gatheredContextGraph value))], optionalPair "inferredRelationshipSummary" (gatheredContextInferredRelationshipSummary value), [("metadata", toJSON (gatheredContextMetadata value))], optionalPair "semanticContext" (gatheredContextSemanticContext value)]) <> fmap toJSON (withoutFields ["focus", "graph", "inferredRelationshipSummary", "metadata", "semanticContext"] (gatheredContextAdditionalProperties value)))

data GatheredContextFocus = GatheredContextFocusAnnotation GatheredContextFocusAnnotationValue | GatheredContextFocusResource GatheredContextFocusResourceValue deriving (Eq, Show)

instance FromJSON GatheredContextFocus where parseJSON = checked "GatheredContextFocus" $ \value -> (GatheredContextFocusAnnotation <$> parseJSON value) <|> (GatheredContextFocusResource <$> parseJSON value)

instance ToJSON GatheredContextFocus where
  toJSON (GatheredContextFocusAnnotation value) = toJSON value
  toJSON (GatheredContextFocusResource value) = toJSON value

data GatheredContextFocusAnnotationValue = GatheredContextFocusAnnotationValue
  { gatheredContextFocusAnnotationValueAnnotation :: Annotation,
    gatheredContextFocusAnnotationValueKind :: GatheredContextFocusAnnotationValueKind,
    gatheredContextFocusAnnotationValueSelected :: Maybe GatheredContextFocusAnnotationValueSelected,
    gatheredContextFocusAnnotationValueSourceResource :: ResourceDescriptor,
    gatheredContextFocusAnnotationValueTargetContext :: Maybe GatheredContextFocusAnnotationValueTargetContext,
    gatheredContextFocusAnnotationValueTargetResource :: Maybe ResourceDescriptor,
    gatheredContextFocusAnnotationValueUserHint :: Maybe Text,
    gatheredContextFocusAnnotationValueAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotationValue where parseJSON = checked "GatheredContextFocusAnnotationValue" $ withObject "GatheredContextFocusAnnotationValue" (\fields -> GatheredContextFocusAnnotationValue <$> (fields .: "annotation") <*> (fields .: "kind") <*> optional fields "selected" <*> (fields .: "sourceResource") <*> optional fields "targetContext" <*> optional fields "targetResource" <*> optional fields "userHint" <*> traverse parseJSON (withoutFields ["annotation", "kind", "selected", "sourceResource", "targetContext", "targetResource", "userHint"] fields))

instance ToJSON GatheredContextFocusAnnotationValue where toJSON value = Object (KM.fromList (concat [[("annotation", toJSON (gatheredContextFocusAnnotationValueAnnotation value))], [("kind", toJSON (gatheredContextFocusAnnotationValueKind value))], optionalPair "selected" (gatheredContextFocusAnnotationValueSelected value), [("sourceResource", toJSON (gatheredContextFocusAnnotationValueSourceResource value))], optionalPair "targetContext" (gatheredContextFocusAnnotationValueTargetContext value), optionalPair "targetResource" (gatheredContextFocusAnnotationValueTargetResource value), optionalPair "userHint" (gatheredContextFocusAnnotationValueUserHint value)]) <> fmap toJSON (withoutFields ["annotation", "kind", "selected", "sourceResource", "targetContext", "targetResource", "userHint"] (gatheredContextFocusAnnotationValueAdditionalProperties value)))

data GatheredContextFocusAnnotationValueKind = GatheredContextFocusAnnotationValueKindAnnotation deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotationValueKind where parseJSON = checked "GatheredContextFocusAnnotationValueKind" $ \value -> if value == String "annotation" then pure GatheredContextFocusAnnotationValueKindAnnotation else fail "unknown enumeration member"

instance ToJSON GatheredContextFocusAnnotationValueKind where toJSON GatheredContextFocusAnnotationValueKindAnnotation = String "annotation"

gatheredContextFocusAnnotationValueKindText :: GatheredContextFocusAnnotationValueKind -> Text
gatheredContextFocusAnnotationValueKindText GatheredContextFocusAnnotationValueKindAnnotation = "annotation"

data GatheredContextFocusAnnotationValueSelected = GatheredContextFocusAnnotationValueSelected
  { gatheredContextFocusAnnotationValueSelectedAfter :: Maybe Text,
    gatheredContextFocusAnnotationValueSelectedBefore :: Maybe Text,
    gatheredContextFocusAnnotationValueSelectedText :: Text,
    gatheredContextFocusAnnotationValueSelectedAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotationValueSelected where parseJSON = checked "GatheredContextFocusAnnotationValueSelected" $ withObject "GatheredContextFocusAnnotationValueSelected" (\fields -> GatheredContextFocusAnnotationValueSelected <$> optional fields "after" <*> optional fields "before" <*> (fields .: "text") <*> traverse parseJSON (withoutFields ["after", "before", "text"] fields))

instance ToJSON GatheredContextFocusAnnotationValueSelected where toJSON value = Object (KM.fromList (concat [optionalPair "after" (gatheredContextFocusAnnotationValueSelectedAfter value), optionalPair "before" (gatheredContextFocusAnnotationValueSelectedBefore value), [("text", toJSON (gatheredContextFocusAnnotationValueSelectedText value))]]) <> fmap toJSON (withoutFields ["after", "before", "text"] (gatheredContextFocusAnnotationValueSelectedAdditionalProperties value)))

data GatheredContextFocusAnnotationValueTargetContext = GatheredContextFocusAnnotationValueTargetContext
  { gatheredContextFocusAnnotationValueTargetContextContent :: Text,
    gatheredContextFocusAnnotationValueTargetContextSummary :: Maybe Text,
    gatheredContextFocusAnnotationValueTargetContextAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotationValueTargetContext where parseJSON = checked "GatheredContextFocusAnnotationValueTargetContext" $ withObject "GatheredContextFocusAnnotationValueTargetContext" (\fields -> GatheredContextFocusAnnotationValueTargetContext <$> (fields .: "content") <*> optional fields "summary" <*> traverse parseJSON (withoutFields ["content", "summary"] fields))

instance ToJSON GatheredContextFocusAnnotationValueTargetContext where toJSON value = Object (KM.fromList (concat [[("content", toJSON (gatheredContextFocusAnnotationValueTargetContextContent value))], optionalPair "summary" (gatheredContextFocusAnnotationValueTargetContextSummary value)]) <> fmap toJSON (withoutFields ["content", "summary"] (gatheredContextFocusAnnotationValueTargetContextAdditionalProperties value)))

data GatheredContextFocusResourceValue = GatheredContextFocusResourceValue
  { gatheredContextFocusResourceValueContent :: Maybe GatheredContextFocusResourceValueContent,
    gatheredContextFocusResourceValueKind :: GatheredContextFocusResourceValueKind,
    gatheredContextFocusResourceValueResource :: ResourceDescriptor,
    gatheredContextFocusResourceValueSuggestedReferences :: Maybe [Text],
    gatheredContextFocusResourceValueSummary :: Maybe Text,
    gatheredContextFocusResourceValueAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusResourceValue where parseJSON = checked "GatheredContextFocusResourceValue" $ withObject "GatheredContextFocusResourceValue" (\fields -> GatheredContextFocusResourceValue <$> optional fields "content" <*> (fields .: "kind") <*> (fields .: "resource") <*> optional fields "suggestedReferences" <*> optional fields "summary" <*> traverse parseJSON (withoutFields ["content", "kind", "resource", "suggestedReferences", "summary"] fields))

instance ToJSON GatheredContextFocusResourceValue where toJSON value = Object (KM.fromList (concat [optionalPair "content" (gatheredContextFocusResourceValueContent value), [("kind", toJSON (gatheredContextFocusResourceValueKind value))], [("resource", toJSON (gatheredContextFocusResourceValueResource value))], optionalPair "suggestedReferences" (gatheredContextFocusResourceValueSuggestedReferences value), optionalPair "summary" (gatheredContextFocusResourceValueSummary value)]) <> fmap toJSON (withoutFields ["content", "kind", "resource", "suggestedReferences", "summary"] (gatheredContextFocusResourceValueAdditionalProperties value)))

data GatheredContextFocusResourceValueContent = GatheredContextFocusResourceValueContent
  { gatheredContextFocusResourceValueContentMain :: Maybe Text,
    gatheredContextFocusResourceValueContentRelated :: Maybe GatheredContextFocusResourceValueContentRelated,
    gatheredContextFocusResourceValueContentAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusResourceValueContent where parseJSON = checked "GatheredContextFocusResourceValueContent" $ withObject "GatheredContextFocusResourceValueContent" (\fields -> GatheredContextFocusResourceValueContent <$> optional fields "main" <*> optional fields "related" <*> traverse parseJSON (withoutFields ["main", "related"] fields))

instance ToJSON GatheredContextFocusResourceValueContent where toJSON value = Object (KM.fromList (concat [optionalPair "main" (gatheredContextFocusResourceValueContentMain value), optionalPair "related" (gatheredContextFocusResourceValueContentRelated value)]) <> fmap toJSON (withoutFields ["main", "related"] (gatheredContextFocusResourceValueContentAdditionalProperties value)))

data GatheredContextFocusResourceValueContentRelated = GatheredContextFocusResourceValueContentRelated
  { gatheredContextFocusResourceValueContentRelatedAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusResourceValueContentRelated where parseJSON = checked "GatheredContextFocusResourceValueContentRelated" $ withObject "GatheredContextFocusResourceValueContentRelated" (\fields -> GatheredContextFocusResourceValueContentRelated <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON GatheredContextFocusResourceValueContentRelated where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (gatheredContextFocusResourceValueContentRelatedAdditionalProperties value)))

data GatheredContextFocusResourceValueKind = GatheredContextFocusResourceValueKindResource deriving (Eq, Show)

instance FromJSON GatheredContextFocusResourceValueKind where parseJSON = checked "GatheredContextFocusResourceValueKind" $ \value -> if value == String "resource" then pure GatheredContextFocusResourceValueKindResource else fail "unknown enumeration member"

instance ToJSON GatheredContextFocusResourceValueKind where toJSON GatheredContextFocusResourceValueKindResource = String "resource"

gatheredContextFocusResourceValueKindText :: GatheredContextFocusResourceValueKind -> Text
gatheredContextFocusResourceValueKindText GatheredContextFocusResourceValueKindResource = "resource"

data GatheredContextMetadata = GatheredContextMetadata
  { gatheredContextMetadataEntityTypeFrequencies :: Maybe GatheredContextMetadataEntityTypeFrequencies,
    gatheredContextMetadataEntityTypes :: Maybe [Text],
    gatheredContextMetadataLanguage :: Maybe Text,
    gatheredContextMetadataResourceType :: Maybe Text,
    gatheredContextMetadataAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextMetadata where parseJSON = checked "GatheredContextMetadata" $ withObject "GatheredContextMetadata" (\fields -> GatheredContextMetadata <$> optional fields "entityTypeFrequencies" <*> optional fields "entityTypes" <*> optional fields "language" <*> optional fields "resourceType" <*> traverse parseJSON (withoutFields ["entityTypeFrequencies", "entityTypes", "language", "resourceType"] fields))

instance ToJSON GatheredContextMetadata where toJSON value = Object (KM.fromList (concat [optionalPair "entityTypeFrequencies" (gatheredContextMetadataEntityTypeFrequencies value), optionalPair "entityTypes" (gatheredContextMetadataEntityTypes value), optionalPair "language" (gatheredContextMetadataLanguage value), optionalPair "resourceType" (gatheredContextMetadataResourceType value)]) <> fmap toJSON (withoutFields ["entityTypeFrequencies", "entityTypes", "language", "resourceType"] (gatheredContextMetadataAdditionalProperties value)))

data GatheredContextMetadataEntityTypeFrequencies = GatheredContextMetadataEntityTypeFrequencies
  { gatheredContextMetadataEntityTypeFrequenciesAdditionalProperties :: KM.KeyMap Integer
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextMetadataEntityTypeFrequencies where parseJSON = checked "GatheredContextMetadataEntityTypeFrequencies" $ withObject "GatheredContextMetadataEntityTypeFrequencies" (\fields -> GatheredContextMetadataEntityTypeFrequencies <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON GatheredContextMetadataEntityTypeFrequencies where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (gatheredContextMetadataEntityTypeFrequenciesAdditionalProperties value)))

data GatheredContextSemanticContext = GatheredContextSemanticContext
  { gatheredContextSemanticContextExcludedEntityTypes :: Maybe [Text],
    gatheredContextSemanticContextSimilar :: [SemanticMatch],
    gatheredContextSemanticContextAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextSemanticContext where parseJSON = checked "GatheredContextSemanticContext" $ withObject "GatheredContextSemanticContext" (\fields -> GatheredContextSemanticContext <$> optional fields "excludedEntityTypes" <*> (fields .: "similar") <*> traverse parseJSON (withoutFields ["excludedEntityTypes", "similar"] fields))

instance ToJSON GatheredContextSemanticContext where toJSON value = Object (KM.fromList (concat [optionalPair "excludedEntityTypes" (gatheredContextSemanticContextExcludedEntityTypes value), [("similar", toJSON (gatheredContextSemanticContextSimilar value))]]) <> fmap toJSON (withoutFields ["excludedEntityTypes", "similar"] (gatheredContextSemanticContextAdditionalProperties value)))
