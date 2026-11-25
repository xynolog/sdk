-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GetResourceResponse (GetResourceResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Annotation
import Xynolog.Internal.Generated.Models.ResourceDescriptor

data GetResourceResponse = GetResourceResponse
  { getResourceResponseResource :: ResourceDescriptor,
    getResourceResponseAnnotations :: [Annotation]
  }
  deriving (Eq, Show)

instance FromJSON GetResourceResponse where parseJSON = checked "GetResourceResponse" $ withObject "GetResourceResponse" (\fields -> GetResourceResponse <$> (fields .: "resource") <*> (fields .: "annotations"))

instance ToJSON GetResourceResponse where toJSON value = Object (KM.fromList (concat [[("resource", toJSON (getResourceResponseResource value))], [("annotations", toJSON (getResourceResponseAnnotations value))]]))
