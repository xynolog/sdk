-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SemanticMatch (SemanticMatch (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ResourceId

data SemanticMatch = SemanticMatch
  { semanticMatchAnnotationId :: Maybe AnnotationId,
    semanticMatchEntityTypes :: Maybe [Text],
    semanticMatchMachineRead :: Maybe Bool,
    semanticMatchResourceId :: ResourceId,
    semanticMatchResourceName :: Text,
    semanticMatchScore :: Scientific,
    semanticMatchText :: Text
  }
  deriving (Eq, Show)

instance FromJSON SemanticMatch where parseJSON = checked "SemanticMatch" $ withObject "SemanticMatch" (\fields -> SemanticMatch <$> optional fields "annotationId" <*> optional fields "entityTypes" <*> optional fields "machineRead" <*> (fields .: "resourceId") <*> (fields .: "resourceName") <*> (fields .: "score") <*> (fields .: "text"))

instance ToJSON SemanticMatch where toJSON value = Object (KM.fromList (concat [optionalPair "annotationId" (semanticMatchAnnotationId value), optionalPair "entityTypes" (semanticMatchEntityTypes value), optionalPair "machineRead" (semanticMatchMachineRead value), [("resourceId", toJSON (semanticMatchResourceId value))], [("resourceName", toJSON (semanticMatchResourceName value))], [("score", toJSON (semanticMatchScore value))], [("text", toJSON (semanticMatchText value))]]))
