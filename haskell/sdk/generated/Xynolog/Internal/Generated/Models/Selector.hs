-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Selector (Selector (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FragmentSelector
import Xynolog.Internal.Generated.Models.SvgSelector
import Xynolog.Internal.Generated.Models.TextPositionSelector
import Xynolog.Internal.Generated.Models.TextQuoteSelector

data Selector = SelectorTextPositionSelector TextPositionSelector | SelectorTextQuoteSelector TextQuoteSelector | SelectorSvgSelector SvgSelector | SelectorFragmentSelector FragmentSelector deriving (Eq, Show)

instance FromJSON Selector where parseJSON = checked "Selector" $ \value -> (SelectorTextPositionSelector <$> parseJSON value) <|> (SelectorTextQuoteSelector <$> parseJSON value) <|> (SelectorSvgSelector <$> parseJSON value) <|> (SelectorFragmentSelector <$> parseJSON value)

instance ToJSON Selector where
  toJSON (SelectorTextPositionSelector value) = toJSON value
  toJSON (SelectorTextQuoteSelector value) = toJSON value
  toJSON (SelectorSvgSelector value) = toJSON value
  toJSON (SelectorFragmentSelector value) = toJSON value
