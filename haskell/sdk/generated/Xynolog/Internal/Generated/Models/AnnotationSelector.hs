-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnnotationSelector (AnnotationSelector (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Selector

data AnnotationSelector = AnnotationSelectorSelector Selector | AnnotationSelectorList [Selector] deriving (Eq, Show)

instance FromJSON AnnotationSelector where parseJSON = checked "AnnotationSelector" $ \value -> (AnnotationSelectorSelector <$> parseJSON value) <|> (AnnotationSelectorList <$> parseJSON value)

instance ToJSON AnnotationSelector where
  toJSON (AnnotationSelectorSelector value) = toJSON value
  toJSON (AnnotationSelectorList value) = toJSON value
