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
    annotationType :: AnnotationType,
    annotationId :: AnnotationId,
    annotationMotivation :: Motivation,
    annotationTarget :: AnnotationTargetValue,
    annotationBody :: Maybe AnnotationBodies,
    annotationCreator :: Maybe Agent,
    annotationCreated :: Text,
    annotationModified :: Maybe Text,
    annotationGenerator :: Maybe OneOrMoreAgents,
    annotationWasAttributedTo :: Maybe OneOrMoreAgents
  }
  deriving (Eq, Show)

instance FromJSON Annotation where parseJSON = checked "Annotation" $ withObject "Annotation" (\fields -> Annotation <$> (fields .: "@context") <*> (fields .: "type") <*> (fields .: "id") <*> (fields .: "motivation") <*> (fields .: "target") <*> optional fields "body" <*> optional fields "creator" <*> (fields .: "created") <*> optional fields "modified" <*> optional fields "generator" <*> optional fields "wasAttributedTo")

instance ToJSON Annotation where toJSON value = Object (KM.fromList (concat [[("@context", toJSON (annotationContext value))], [("type", toJSON (annotationType value))], [("id", toJSON (annotationId value))], [("motivation", toJSON (annotationMotivation value))], [("target", toJSON (annotationTarget value))], optionalPair "body" (annotationBody value), optionalPair "creator" (annotationCreator value), [("created", toJSON (annotationCreated value))], optionalPair "modified" (annotationModified value), optionalPair "generator" (annotationGenerator value), optionalPair "wasAttributedTo" (annotationWasAttributedTo value)]))

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
