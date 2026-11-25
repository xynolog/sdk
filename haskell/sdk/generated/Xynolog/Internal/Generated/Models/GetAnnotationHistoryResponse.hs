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
  { getAnnotationHistoryResponseEvents :: [AttributedEvent],
    getAnnotationHistoryResponseTotal :: Scientific,
    getAnnotationHistoryResponseAnnotationId :: AnnotationId,
    getAnnotationHistoryResponseResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON GetAnnotationHistoryResponse where parseJSON = checked "GetAnnotationHistoryResponse" $ withObject "GetAnnotationHistoryResponse" (\fields -> GetAnnotationHistoryResponse <$> (fields .: "events") <*> (fields .: "total") <*> (fields .: "annotationId") <*> (fields .: "resourceId"))

instance ToJSON GetAnnotationHistoryResponse where toJSON value = Object (KM.fromList (concat [[("events", toJSON (getAnnotationHistoryResponseEvents value))], [("total", toJSON (getAnnotationHistoryResponseTotal value))], [("annotationId", toJSON (getAnnotationHistoryResponseAnnotationId value))], [("resourceId", toJSON (getAnnotationHistoryResponseResourceId value))]]))
