-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseAnnotationHistoryRequest (BrowseAnnotationHistoryRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ResourceId

data BrowseAnnotationHistoryRequest = BrowseAnnotationHistoryRequest
  { browseAnnotationHistoryRequestResourceId :: ResourceId,
    browseAnnotationHistoryRequestAnnotationId :: AnnotationId
  }
  deriving (Eq, Show)

instance FromJSON BrowseAnnotationHistoryRequest where parseJSON = checked "BrowseAnnotationHistoryRequest" $ withObject "BrowseAnnotationHistoryRequest" (\fields -> BrowseAnnotationHistoryRequest <$> (fields .: "resourceId") <*> (fields .: "annotationId"))

instance ToJSON BrowseAnnotationHistoryRequest where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (browseAnnotationHistoryRequestResourceId value))], [("annotationId", toJSON (browseAnnotationHistoryRequestAnnotationId value))]]))
