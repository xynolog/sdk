-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GetAnnotationsResponse (GetAnnotationsResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Annotation
import Xynolog.Internal.Generated.Models.Motivation

data GetAnnotationsResponse = GetAnnotationsResponse
  { getAnnotationsResponseAnnotations :: [Annotation],
    getAnnotationsResponseMotivation :: Maybe Motivation,
    getAnnotationsResponseTotal :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON GetAnnotationsResponse where parseJSON = checked "GetAnnotationsResponse" $ withObject "GetAnnotationsResponse" (\fields -> GetAnnotationsResponse <$> (fields .: "annotations") <*> optional fields "motivation" <*> (fields .: "total"))

instance ToJSON GetAnnotationsResponse where toJSON value = Object (KM.fromList (concat [[("annotations", toJSON (getAnnotationsResponseAnnotations value))], optionalPair "motivation" (getAnnotationsResponseMotivation value), [("total", toJSON (getAnnotationsResponseTotal value))]]))
