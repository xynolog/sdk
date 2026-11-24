-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Annotation (Annotation (..), AnnotationTargetInline (..), AnnotationType (..), annotationTypeText, AnnotationU40_context (..), annotationU40_contextText) where

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
  { annotationU40_context :: AnnotationU40_context,
    annotationBody :: Maybe AnnotationBodies,
    annotationCreated :: Text,
    annotationCreator :: Maybe Agent,
    annotationGenerator :: Maybe OneOrMoreAgents,
    annotationId :: AnnotationId,
    annotationModified :: Maybe Text,
    annotationMotivation :: Motivation,
    annotationTarget :: AnnotationTargetInline,
    annotationType :: AnnotationType,
    annotationWasAttributedTo :: Maybe OneOrMoreAgents,
    annotationAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON Annotation where parseJSON = checked "Annotation" $ withObject "Annotation" (\fields -> Annotation <$> (fields .: "@context") <*> optional fields "body" <*> (fields .: "created") <*> optional fields "creator" <*> optional fields "generator" <*> (fields .: "id") <*> optional fields "modified" <*> (fields .: "motivation") <*> (fields .: "target") <*> (fields .: "type") <*> optional fields "wasAttributedTo" <*> traverse parseJSON (withoutFields ["@context", "body", "created", "creator", "generator", "id", "modified", "motivation", "target", "type", "wasAttributedTo"] fields))

instance ToJSON Annotation where toJSON value = Object (KM.fromList (concat [[("@context", toJSON (annotationU40_context value))], optionalPair "body" (annotationBody value), [("created", toJSON (annotationCreated value))], optionalPair "creator" (annotationCreator value), optionalPair "generator" (annotationGenerator value), [("id", toJSON (annotationId value))], optionalPair "modified" (annotationModified value), [("motivation", toJSON (annotationMotivation value))], [("target", toJSON (annotationTarget value))], [("type", toJSON (annotationType value))], optionalPair "wasAttributedTo" (annotationWasAttributedTo value)]) <> fmap toJSON (withoutFields ["@context", "body", "created", "creator", "generator", "id", "modified", "motivation", "target", "type", "wasAttributedTo"] (annotationAdditionalProperties value)))

data AnnotationTargetInline = AnnotationTargetInlineResourceId ResourceId | AnnotationTargetInlineAnnotationTarget AnnotationTarget deriving (Eq, Show)

instance FromJSON AnnotationTargetInline where parseJSON = checked "AnnotationTargetInline" $ \value -> (AnnotationTargetInlineResourceId <$> parseJSON value) <|> (AnnotationTargetInlineAnnotationTarget <$> parseJSON value)

instance ToJSON AnnotationTargetInline where
  toJSON (AnnotationTargetInlineResourceId value) = toJSON value
  toJSON (AnnotationTargetInlineAnnotationTarget value) = toJSON value

data AnnotationType = AnnotationTypeAnnotation deriving (Eq, Show)

instance FromJSON AnnotationType where parseJSON = checked "AnnotationType" $ \value -> if value == String "Annotation" then pure AnnotationTypeAnnotation else fail "unknown enumeration member"

instance ToJSON AnnotationType where toJSON AnnotationTypeAnnotation = String "Annotation"

annotationTypeText :: AnnotationType -> Text
annotationTypeText AnnotationTypeAnnotation = "Annotation"

data AnnotationU40_context = AnnotationU40_contextHttpU3a_U2f_U2f_wwwU2e_w3U2e_orgU2f_nsU2f_annoU2e_jsonld deriving (Eq, Show)

instance FromJSON AnnotationU40_context where parseJSON = checked "AnnotationU40_context" $ \value -> if value == String "http://www.w3.org/ns/anno.jsonld" then pure AnnotationU40_contextHttpU3a_U2f_U2f_wwwU2e_w3U2e_orgU2f_nsU2f_annoU2e_jsonld else fail "unknown enumeration member"

instance ToJSON AnnotationU40_context where toJSON AnnotationU40_contextHttpU3a_U2f_U2f_wwwU2e_w3U2e_orgU2f_nsU2f_annoU2e_jsonld = String "http://www.w3.org/ns/anno.jsonld"

annotationU40_contextText :: AnnotationU40_context -> Text
annotationU40_contextText AnnotationU40_contextHttpU3a_U2f_U2f_wwwU2e_w3U2e_orgU2f_nsU2f_annoU2e_jsonld = "http://www.w3.org/ns/anno.jsonld"
