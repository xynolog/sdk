-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnnotationBodies (AnnotationBodies (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationBody

data AnnotationBodies = AnnotationBodiesAnnotationBody AnnotationBody | AnnotationBodiesList [AnnotationBody] deriving (Eq, Show)

instance FromJSON AnnotationBodies where parseJSON = checked "AnnotationBodies" $ \value -> (AnnotationBodiesAnnotationBody <$> parseJSON value) <|> (AnnotationBodiesList <$> parseJSON value)

instance ToJSON AnnotationBodies where
  toJSON (AnnotationBodiesAnnotationBody value) = toJSON value
  toJSON (AnnotationBodiesList value) = toJSON value
