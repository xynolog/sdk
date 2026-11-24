-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnnotationBody (AnnotationBody (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.SpecificResource
import Xynolog.Internal.Generated.Models.TextualBody

data AnnotationBody = AnnotationBodyTextualBody TextualBody | AnnotationBodySpecificResource SpecificResource deriving (Eq, Show)

instance FromJSON AnnotationBody where parseJSON = checked "AnnotationBody" $ \value -> (AnnotationBodyTextualBody <$> parseJSON value) <|> (AnnotationBodySpecificResource <$> parseJSON value)

instance ToJSON AnnotationBody where
  toJSON (AnnotationBodyTextualBody value) = toJSON value
  toJSON (AnnotationBodySpecificResource value) = toJSON value
