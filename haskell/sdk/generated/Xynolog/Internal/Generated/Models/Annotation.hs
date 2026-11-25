-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Annotation (Annotation (..), AnnotationContext (..), annotationContextText, AnnotationTargetValue (..), AnnotationType (..), annotationTypeText) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Agent
import Xynolog.Internal.Generated.Models.AnnotationBodies
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.AnnotationTarget
import Xynolog.Internal.Generated.Models.Motivation
import Xynolog.Internal.Generated.Models.OneOrMoreAgents
import Xynolog.Internal.Generated.Models.ResourceId

data Annotation = Annotation
  { annotationContext :: AnnotationContext,
    annotationBody :: Maybe AnnotationBodies,
    annotationCreated :: Text,
    annotationCreator :: Maybe Agent,
    annotationGenerator :: Maybe OneOrMoreAgents,
    annotationId :: AnnotationId,
    annotationModified :: Maybe Text,
    annotationMotivation :: Motivation,
    annotationTarget :: AnnotationTargetValue,
    annotationType :: AnnotationType,
    annotationWasAttributedTo :: Maybe OneOrMoreAgents,
    annotationAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON Annotation where parseJSON = checked "Annotation" $ withObject "Annotation" (\fields -> Annotation <$> (fields .: "@context") <*> optional fields "body" <*> (fields .: "created") <*> optional fields "creator" <*> optional fields "generator" <*> (fields .: "id") <*> optional fields "modified" <*> (fields .: "motivation") <*> (fields .: "target") <*> (fields .: "type") <*> optional fields "wasAttributedTo" <*> traverse parseJSON (withoutFields ["@context", "body", "created", "creator", "generator", "id", "modified", "motivation", "target", "type", "wasAttributedTo"] fields))

instance ToJSON Annotation where toJSON value = Object (KM.fromList (concat [[("@context", toJSON (annotationContext value))], optionalPair "body" (annotationBody value), [("created", toJSON (annotationCreated value))], optionalPair "creator" (annotationCreator value), optionalPair "generator" (annotationGenerator value), [("id", toJSON (annotationId value))], optionalPair "modified" (annotationModified value), [("motivation", toJSON (annotationMotivation value))], [("target", toJSON (annotationTarget value))], [("type", toJSON (annotationType value))], optionalPair "wasAttributedTo" (annotationWasAttributedTo value)]) <> fmap toJSON (withoutFields ["@context", "body", "created", "creator", "generator", "id", "modified", "motivation", "target", "type", "wasAttributedTo"] (annotationAdditionalProperties value)))

data AnnotationContext = AnnotationContextHttpWwwW3OrgNsAnnoJsonld deriving (Eq, Show)

instance FromJSON AnnotationContext where parseJSON = checked "AnnotationContext" $ \value -> if value == String "http://www.w3.org/ns/anno.jsonld" then pure AnnotationContextHttpWwwW3OrgNsAnnoJsonld else fail "unknown enumeration member"

instance ToJSON AnnotationContext where toJSON AnnotationContextHttpWwwW3OrgNsAnnoJsonld = String "http://www.w3.org/ns/anno.jsonld"

annotationContextText :: AnnotationContext -> Text
annotationContextText AnnotationContextHttpWwwW3OrgNsAnnoJsonld = "http://www.w3.org/ns/anno.jsonld"

data AnnotationTargetValue = AnnotationTargetValueResourceId ResourceId | AnnotationTargetValueAnnotationTarget AnnotationTarget deriving (Eq, Show)

instance FromJSON AnnotationTargetValue where parseJSON = checked "AnnotationTargetValue" $ \value -> (AnnotationTargetValueResourceId <$> parseJSON value) <|> (AnnotationTargetValueAnnotationTarget <$> parseJSON value)

instance ToJSON AnnotationTargetValue where
  toJSON (AnnotationTargetValueResourceId value) = toJSON value
  toJSON (AnnotationTargetValueAnnotationTarget value) = toJSON value

data AnnotationType = AnnotationTypeAnnotation deriving (Eq, Show)

instance FromJSON AnnotationType where parseJSON = checked "AnnotationType" $ \value -> if value == String "Annotation" then pure AnnotationTypeAnnotation else fail "unknown enumeration member"

instance ToJSON AnnotationType where toJSON AnnotationTypeAnnotation = String "Annotation"

annotationTypeText :: AnnotationType -> Text
annotationTypeText AnnotationTypeAnnotation = "Annotation"
