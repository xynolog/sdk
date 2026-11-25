-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnnotationBodyUpdatedPayload (AnnotationBodyUpdatedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.BodyOperation

data AnnotationBodyUpdatedPayload = AnnotationBodyUpdatedPayload
  { annotationBodyUpdatedPayloadAnnotationId :: AnnotationId,
    annotationBodyUpdatedPayloadOperations :: [BodyOperation]
  }
  deriving (Eq, Show)

instance FromJSON AnnotationBodyUpdatedPayload where parseJSON = checked "AnnotationBodyUpdatedPayload" $ withObject "AnnotationBodyUpdatedPayload" (\fields -> AnnotationBodyUpdatedPayload <$> (fields .: "annotationId") <*> (fields .: "operations"))

instance ToJSON AnnotationBodyUpdatedPayload where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (annotationBodyUpdatedPayloadAnnotationId value))], [("operations", toJSON (annotationBodyUpdatedPayloadOperations value))]]))
