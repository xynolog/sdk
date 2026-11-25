-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnnotationTarget (AnnotationTarget (..), AnnotationTargetType (..), annotationTargetTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationSelector
import Xynolog.Internal.Generated.Models.ResourceId

data AnnotationTarget = AnnotationTarget
  { annotationTargetSelector :: Maybe AnnotationSelector,
    annotationTargetSource :: ResourceId,
    annotationTargetType :: Maybe AnnotationTargetType
  }
  deriving (Eq, Show)

instance FromJSON AnnotationTarget where parseJSON = checked "AnnotationTarget" $ withObject "AnnotationTarget" (\fields -> AnnotationTarget <$> optional fields "selector" <*> (fields .: "source") <*> optional fields "type")

instance ToJSON AnnotationTarget where toJSON value = Object (KM.fromList (concat [optionalPair "selector" (annotationTargetSelector value), [("source", toJSON (annotationTargetSource value))], optionalPair "type" (annotationTargetType value)]))

data AnnotationTargetType = AnnotationTargetTypeSpecificResource deriving (Eq, Show)

instance FromJSON AnnotationTargetType where parseJSON = checked "AnnotationTargetType" $ \value -> if value == String "SpecificResource" then pure AnnotationTargetTypeSpecificResource else fail "unknown enumeration member"

instance ToJSON AnnotationTargetType where toJSON AnnotationTargetTypeSpecificResource = String "SpecificResource"

annotationTargetTypeText :: AnnotationTargetType -> Text
annotationTargetTypeText AnnotationTargetTypeSpecificResource = "SpecificResource"
