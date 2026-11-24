-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.OneOrMoreStrings (OneOrMoreStrings (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data OneOrMoreStrings = OneOrMoreStringsText Text | OneOrMoreStringsList [Text] deriving (Eq, Show)

instance FromJSON OneOrMoreStrings where parseJSON = checked "OneOrMoreStrings" $ \value -> (OneOrMoreStringsText <$> parseJSON value) <|> (OneOrMoreStringsList <$> parseJSON value)

instance ToJSON OneOrMoreStrings where
  toJSON (OneOrMoreStringsText value) = toJSON value
  toJSON (OneOrMoreStringsList value) = toJSON value
