-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnnotationAddedPayload (AnnotationAddedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Annotation

data AnnotationAddedPayload = AnnotationAddedPayload
  { annotationAddedPayloadAnnotation :: Annotation,
    annotationAddedPayloadContentChecksum :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON AnnotationAddedPayload where parseJSON = checked "AnnotationAddedPayload" $ withObject "AnnotationAddedPayload" (\fields -> AnnotationAddedPayload <$> (fields .: "annotation") <*> optional fields "contentChecksum")

instance ToJSON AnnotationAddedPayload where toJSON value = Object (KM.fromList (concat [[("annotation", toJSON (annotationAddedPayloadAnnotation value))], optionalPair "contentChecksum" (annotationAddedPayloadContentChecksum value)]))
