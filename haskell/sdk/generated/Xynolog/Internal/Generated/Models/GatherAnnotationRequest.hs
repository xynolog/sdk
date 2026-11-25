-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherAnnotationRequest (GatherAnnotationRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.GatherAnnotationOptions
import Xynolog.Internal.Generated.Models.ResourceId

data GatherAnnotationRequest = GatherAnnotationRequest
  { gatherAnnotationRequestAnnotationId :: AnnotationId,
    gatherAnnotationRequestResourceId :: ResourceId,
    gatherAnnotationRequestOptions :: Maybe GatherAnnotationOptions
  }
  deriving (Eq, Show)

instance FromJSON GatherAnnotationRequest where parseJSON = checked "GatherAnnotationRequest" $ withObject "GatherAnnotationRequest" (\fields -> GatherAnnotationRequest <$> (fields .: "annotationId") <*> (fields .: "resourceId") <*> optional fields "options")

instance ToJSON GatherAnnotationRequest where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (gatherAnnotationRequestAnnotationId value))], [("resourceId", toJSON (gatherAnnotationRequestResourceId value))], optionalPair "options" (gatherAnnotationRequestOptions value)]))
