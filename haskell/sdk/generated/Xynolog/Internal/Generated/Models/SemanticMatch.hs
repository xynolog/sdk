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
  { semanticMatchText :: Text,
    semanticMatchResourceId :: ResourceId,
    semanticMatchResourceName :: Text,
    semanticMatchAnnotationId :: Maybe AnnotationId,
    semanticMatchScore :: Scientific,
    semanticMatchEntityTypes :: Maybe [Text],
    semanticMatchMachineRead :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON SemanticMatch where parseJSON = checked "SemanticMatch" $ withObject "SemanticMatch" (\fields -> SemanticMatch <$> (fields .: "text") <*> (fields .: "resourceId") <*> (fields .: "resourceName") <*> optional fields "annotationId" <*> (fields .: "score") <*> optional fields "entityTypes" <*> optional fields "machineRead")

instance ToJSON SemanticMatch where toJSON value = Object (KM.fromList (concat [[("text", toJSON (semanticMatchText value))], [("resourceId", toJSON (semanticMatchResourceId value))], [("resourceName", toJSON (semanticMatchResourceName value))], optionalPair "annotationId" (semanticMatchAnnotationId value), [("score", toJSON (semanticMatchScore value))], optionalPair "entityTypes" (semanticMatchEntityTypes value), optionalPair "machineRead" (semanticMatchMachineRead value)]))
