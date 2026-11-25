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
  { browseAnnotationRequestAnnotationId :: AnnotationId,
    browseAnnotationRequestResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON BrowseAnnotationRequest where parseJSON = checked "BrowseAnnotationRequest" $ withObject "BrowseAnnotationRequest" (\fields -> BrowseAnnotationRequest <$> (fields .: "annotationId") <*> (fields .: "resourceId"))

instance ToJSON BrowseAnnotationRequest where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (browseAnnotationRequestAnnotationId value))], [("resourceId", toJSON (browseAnnotationRequestResourceId value))]]))
