-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseAnnotationRequest (BrowseAnnotationRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ResourceId

data BrowseAnnotationRequest = BrowseAnnotationRequest
  { browseAnnotationRequestResourceId :: ResourceId,
    browseAnnotationRequestAnnotationId :: AnnotationId
  }
  deriving (Eq, Show)

instance FromJSON BrowseAnnotationRequest where parseJSON = checked "BrowseAnnotationRequest" $ withObject "BrowseAnnotationRequest" (\fields -> BrowseAnnotationRequest <$> (fields .: "resourceId") <*> (fields .: "annotationId"))

instance ToJSON BrowseAnnotationRequest where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (browseAnnotationRequestResourceId value))], [("annotationId", toJSON (browseAnnotationRequestAnnotationId value))]]))
