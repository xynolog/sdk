-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GetAnnotationHistoryResponse (GetAnnotationHistoryResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.AttributedEvent
import Xynolog.Internal.Generated.Models.ResourceId

data GetAnnotationHistoryResponse = GetAnnotationHistoryResponse
  { getAnnotationHistoryResponseAnnotationId :: AnnotationId,
    getAnnotationHistoryResponseEvents :: [AttributedEvent],
    getAnnotationHistoryResponseResourceId :: ResourceId,
    getAnnotationHistoryResponseTotal :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON GetAnnotationHistoryResponse where parseJSON = checked "GetAnnotationHistoryResponse" $ withObject "GetAnnotationHistoryResponse" (\fields -> GetAnnotationHistoryResponse <$> (fields .: "annotationId") <*> (fields .: "events") <*> (fields .: "resourceId") <*> (fields .: "total"))

instance ToJSON GetAnnotationHistoryResponse where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (getAnnotationHistoryResponseAnnotationId value))], [("events", toJSON (getAnnotationHistoryResponseEvents value))], [("resourceId", toJSON (getAnnotationHistoryResponseResourceId value))], [("total", toJSON (getAnnotationHistoryResponseTotal value))]]))
