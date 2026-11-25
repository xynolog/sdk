-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatheredContext (GatheredContext (..), GatheredContextFocus (..), GatheredContextFocusAnnotation (..), GatheredContextFocusAnnotationKind (..), gatheredContextFocusAnnotationKindText, GatheredContextFocusAnnotationSelected (..), GatheredContextFocusAnnotationTargetContext (..), GatheredContextFocusResource (..), GatheredContextFocusResourceContent (..), GatheredContextFocusResourceKind (..), gatheredContextFocusResourceKindText, GatheredContextMetadata (..), GatheredContextSemanticContext (..)) where

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
    gatheredContextSemanticContext :: Maybe GatheredContextSemanticContext,
    gatheredContextMetadata :: GatheredContextMetadata,
    gatheredContextInferredRelationshipSummary :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GatheredContext where parseJSON = checked "GatheredContext" $ withObject "GatheredContext" (\fields -> GatheredContext <$> (fields .: "focus") <*> (fields .: "graph") <*> optional fields "semanticContext" <*> (fields .: "metadata") <*> optional fields "inferredRelationshipSummary")

instance ToJSON GatheredContext where toJSON value = Object (KM.fromList (concat [[("focus", toJSON (gatheredContextFocus value))], [("graph", toJSON (gatheredContextGraph value))], optionalPair "semanticContext" (gatheredContextSemanticContext value), [("metadata", toJSON (gatheredContextMetadata value))], optionalPair "inferredRelationshipSummary" (gatheredContextInferredRelationshipSummary value)]))

data GatheredContextFocus = GatheredContextFocusAnnotation GatheredContextFocusAnnotation | GatheredContextFocusResource GatheredContextFocusResource deriving (Eq, Show)

instance FromJSON GatheredContextFocus where parseJSON = checked "GatheredContextFocus" $ \value -> readMember "GatheredContextFocus" [([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "annotation", "sourceResource"], signatureAllowed = Nothing, signatureFixed = [("kind", [String "annotation"])], signaturePattern = Nothing, signatureValues = Nothing}], GatheredContextFocusAnnotation <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "resource"], signatureAllowed = Nothing, signatureFixed = [("kind", [String "resource"])], signaturePattern = Nothing, signatureValues = Nothing}], GatheredContextFocusResource <$> parseJSON value)] value

instance ToJSON GatheredContextFocus where
  toJSON (GatheredContextFocusAnnotation value) = toJSON value
  toJSON (GatheredContextFocusResource value) = toJSON value

data GatheredContextFocusAnnotation = MkGatheredContextFocusAnnotation
  { gatheredContextFocusAnnotationKind :: GatheredContextFocusAnnotationKind,
    gatheredContextFocusAnnotationAnnotation :: Annotation,
    gatheredContextFocusAnnotationSourceResource :: ResourceDescriptor,
    gatheredContextFocusAnnotationSelected :: Maybe GatheredContextFocusAnnotationSelected,
    gatheredContextFocusAnnotationUserHint :: Maybe Text,
    gatheredContextFocusAnnotationTargetResource :: Maybe ResourceDescriptor,
    gatheredContextFocusAnnotationTargetContext :: Maybe GatheredContextFocusAnnotationTargetContext
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotation where parseJSON = checked "GatheredContextFocusAnnotation" $ withObject "GatheredContextFocusAnnotation" (\fields -> MkGatheredContextFocusAnnotation <$> (fields .: "kind") <*> (fields .: "annotation") <*> (fields .: "sourceResource") <*> optional fields "selected" <*> optional fields "userHint" <*> optional fields "targetResource" <*> optional fields "targetContext")

instance ToJSON GatheredContextFocusAnnotation where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (gatheredContextFocusAnnotationKind value))], [("annotation", toJSON (gatheredContextFocusAnnotationAnnotation value))], [("sourceResource", toJSON (gatheredContextFocusAnnotationSourceResource value))], optionalPair "selected" (gatheredContextFocusAnnotationSelected value), optionalPair "userHint" (gatheredContextFocusAnnotationUserHint value), optionalPair "targetResource" (gatheredContextFocusAnnotationTargetResource value), optionalPair "targetContext" (gatheredContextFocusAnnotationTargetContext value)]))

data GatheredContextFocusAnnotationKind = GatheredContextFocusAnnotationKindAnnotation deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotationKind where parseJSON = checked "GatheredContextFocusAnnotationKind" $ \value -> if value == String "annotation" then pure GatheredContextFocusAnnotationKindAnnotation else fail "unknown enumeration member"

instance ToJSON GatheredContextFocusAnnotationKind where toJSON GatheredContextFocusAnnotationKindAnnotation = String "annotation"

gatheredContextFocusAnnotationKindText :: GatheredContextFocusAnnotationKind -> Text
gatheredContextFocusAnnotationKindText GatheredContextFocusAnnotationKindAnnotation = "annotation"

data GatheredContextFocusAnnotationSelected = GatheredContextFocusAnnotationSelected
  { gatheredContextFocusAnnotationSelectedBefore :: Maybe Text,
    gatheredContextFocusAnnotationSelectedText :: Text,
    gatheredContextFocusAnnotationSelectedAfter :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotationSelected where parseJSON = checked "GatheredContextFocusAnnotationSelected" $ withObject "GatheredContextFocusAnnotationSelected" (\fields -> GatheredContextFocusAnnotationSelected <$> optional fields "before" <*> (fields .: "text") <*> optional fields "after")

instance ToJSON GatheredContextFocusAnnotationSelected where toJSON value = Object (KM.fromList (concat [optionalPair "before" (gatheredContextFocusAnnotationSelectedBefore value), [("text", toJSON (gatheredContextFocusAnnotationSelectedText value))], optionalPair "after" (gatheredContextFocusAnnotationSelectedAfter value)]))

data GatheredContextFocusAnnotationTargetContext = GatheredContextFocusAnnotationTargetContext
  { gatheredContextFocusAnnotationTargetContextContent :: Text,
    gatheredContextFocusAnnotationTargetContextSummary :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusAnnotationTargetContext where parseJSON = checked "GatheredContextFocusAnnotationTargetContext" $ withObject "GatheredContextFocusAnnotationTargetContext" (\fields -> GatheredContextFocusAnnotationTargetContext <$> (fields .: "content") <*> optional fields "summary")

instance ToJSON GatheredContextFocusAnnotationTargetContext where toJSON value = Object (KM.fromList (concat [[("content", toJSON (gatheredContextFocusAnnotationTargetContextContent value))], optionalPair "summary" (gatheredContextFocusAnnotationTargetContextSummary value)]))

data GatheredContextFocusResource = MkGatheredContextFocusResource
  { gatheredContextFocusResourceKind :: GatheredContextFocusResourceKind,
    gatheredContextFocusResourceResource :: ResourceDescriptor,
    gatheredContextFocusResourceSummary :: Maybe Text,
    gatheredContextFocusResourceSuggestedReferences :: Maybe [Text],
    gatheredContextFocusResourceContent :: Maybe GatheredContextFocusResourceContent
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusResource where parseJSON = checked "GatheredContextFocusResource" $ withObject "GatheredContextFocusResource" (\fields -> MkGatheredContextFocusResource <$> (fields .: "kind") <*> (fields .: "resource") <*> optional fields "summary" <*> optional fields "suggestedReferences" <*> optional fields "content")

instance ToJSON GatheredContextFocusResource where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (gatheredContextFocusResourceKind value))], [("resource", toJSON (gatheredContextFocusResourceResource value))], optionalPair "summary" (gatheredContextFocusResourceSummary value), optionalPair "suggestedReferences" (gatheredContextFocusResourceSuggestedReferences value), optionalPair "content" (gatheredContextFocusResourceContent value)]))

data GatheredContextFocusResourceContent = GatheredContextFocusResourceContent
  { gatheredContextFocusResourceContentMain :: Maybe Text,
    gatheredContextFocusResourceContentRelated :: Maybe (KM.KeyMap Text)
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextFocusResourceContent where parseJSON = checked "GatheredContextFocusResourceContent" $ withObject "GatheredContextFocusResourceContent" (\fields -> GatheredContextFocusResourceContent <$> optional fields "main" <*> optional fields "related")

instance ToJSON GatheredContextFocusResourceContent where toJSON value = Object (KM.fromList (concat [optionalPair "main" (gatheredContextFocusResourceContentMain value), optionalPair "related" (gatheredContextFocusResourceContentRelated value)]))

data GatheredContextFocusResourceKind = GatheredContextFocusResourceKindResource deriving (Eq, Show)

instance FromJSON GatheredContextFocusResourceKind where parseJSON = checked "GatheredContextFocusResourceKind" $ \value -> if value == String "resource" then pure GatheredContextFocusResourceKindResource else fail "unknown enumeration member"

instance ToJSON GatheredContextFocusResourceKind where toJSON GatheredContextFocusResourceKindResource = String "resource"

gatheredContextFocusResourceKindText :: GatheredContextFocusResourceKind -> Text
gatheredContextFocusResourceKindText GatheredContextFocusResourceKindResource = "resource"

data GatheredContextMetadata = GatheredContextMetadata
  { gatheredContextMetadataResourceType :: Maybe Text,
    gatheredContextMetadataLanguage :: Maybe Text,
    gatheredContextMetadataEntityTypes :: Maybe [Text],
    gatheredContextMetadataEntityTypeFrequencies :: Maybe (KM.KeyMap Integer)
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextMetadata where parseJSON = checked "GatheredContextMetadata" $ withObject "GatheredContextMetadata" (\fields -> GatheredContextMetadata <$> optional fields "resourceType" <*> optional fields "language" <*> optional fields "entityTypes" <*> optional fields "entityTypeFrequencies")

instance ToJSON GatheredContextMetadata where toJSON value = Object (KM.fromList (concat [optionalPair "resourceType" (gatheredContextMetadataResourceType value), optionalPair "language" (gatheredContextMetadataLanguage value), optionalPair "entityTypes" (gatheredContextMetadataEntityTypes value), optionalPair "entityTypeFrequencies" (gatheredContextMetadataEntityTypeFrequencies value)]))

data GatheredContextSemanticContext = GatheredContextSemanticContext
  { gatheredContextSemanticContextSimilar :: [SemanticMatch],
    gatheredContextSemanticContextExcludedEntityTypes :: Maybe [Text]
  }
  deriving (Eq, Show)

instance FromJSON GatheredContextSemanticContext where parseJSON = checked "GatheredContextSemanticContext" $ withObject "GatheredContextSemanticContext" (\fields -> GatheredContextSemanticContext <$> (fields .: "similar") <*> optional fields "excludedEntityTypes")

instance ToJSON GatheredContextSemanticContext where toJSON value = Object (KM.fromList (concat [[("similar", toJSON (gatheredContextSemanticContextSimilar value))], optionalPair "excludedEntityTypes" (gatheredContextSemanticContextExcludedEntityTypes value)]))
