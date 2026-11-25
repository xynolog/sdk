-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GetAnnotationResponse (GetAnnotationResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Annotation
import Xynolog.Internal.Generated.Models.ResourceDescriptor

data GetAnnotationResponse = GetAnnotationResponse
  { getAnnotationResponseAnnotation :: Annotation,
    getAnnotationResponseResource :: Maybe ResourceDescriptor,
    getAnnotationResponseResolvedResource :: Maybe ResourceDescriptor
  }
  deriving (Eq, Show)

instance FromJSON GetAnnotationResponse where parseJSON = checked "GetAnnotationResponse" $ withObject "GetAnnotationResponse" (\fields -> GetAnnotationResponse <$> (fields .: "annotation") <*> (fields .: "resource") <*> (fields .: "resolvedResource"))

instance ToJSON GetAnnotationResponse where toJSON value = Object (KM.fromList (concat [[("annotation", toJSON (getAnnotationResponseAnnotation value))], [("resource", toJSON (getAnnotationResponseResource value))], [("resolvedResource", toJSON (getAnnotationResponseResolvedResource value))]]))
