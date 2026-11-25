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
  { annotationTargetType :: Maybe AnnotationTargetType,
    annotationTargetSource :: ResourceId,
    annotationTargetSelector :: Maybe AnnotationSelector
  }
  deriving (Eq, Show)

instance FromJSON AnnotationTarget where parseJSON = checked "AnnotationTarget" $ withObject "AnnotationTarget" (\fields -> AnnotationTarget <$> optional fields "type" <*> (fields .: "source") <*> optional fields "selector")

instance ToJSON AnnotationTarget where toJSON value = Object (KM.fromList (concat [optionalPair "type" (annotationTargetType value), [("source", toJSON (annotationTargetSource value))], optionalPair "selector" (annotationTargetSelector value)]))

data AnnotationTargetType = AnnotationTargetTypeSpecificResource deriving (Eq, Show)

instance FromJSON AnnotationTargetType where parseJSON = checked "AnnotationTargetType" $ \value -> if value == String "SpecificResource" then pure AnnotationTargetTypeSpecificResource else fail "unknown enumeration member"

instance ToJSON AnnotationTargetType where toJSON AnnotationTargetTypeSpecificResource = String "SpecificResource"

annotationTargetTypeText :: AnnotationTargetType -> Text
annotationTargetTypeText AnnotationTargetTypeSpecificResource = "SpecificResource"
