-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnnotationRemovedPayload (AnnotationRemovedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId

data AnnotationRemovedPayload = AnnotationRemovedPayload
  { annotationRemovedPayloadAnnotationId :: AnnotationId
  }
  deriving (Eq, Show)

instance FromJSON AnnotationRemovedPayload where parseJSON = checked "AnnotationRemovedPayload" $ withObject "AnnotationRemovedPayload" (\fields -> AnnotationRemovedPayload <$> (fields .: "annotationId"))

instance ToJSON AnnotationRemovedPayload where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (annotationRemovedPayloadAnnotationId value))]]))
