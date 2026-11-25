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
  { browseAnnotationHistoryRequestAnnotationId :: AnnotationId,
    browseAnnotationHistoryRequestResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON BrowseAnnotationHistoryRequest where parseJSON = checked "BrowseAnnotationHistoryRequest" $ withObject "BrowseAnnotationHistoryRequest" (\fields -> BrowseAnnotationHistoryRequest <$> (fields .: "annotationId") <*> (fields .: "resourceId"))

instance ToJSON BrowseAnnotationHistoryRequest where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (browseAnnotationHistoryRequestAnnotationId value))], [("resourceId", toJSON (browseAnnotationHistoryRequestResourceId value))]]))
