-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.EnginesWithLimits (EnginesWithLimits (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.EngineWithLimits

newtype EnginesWithLimits = EnginesWithLimits {enginesWithLimitsValue :: [EngineWithLimits]} deriving (Eq, Show)

instance FromJSON EnginesWithLimits where parseJSON = checked "EnginesWithLimits" $ \value -> EnginesWithLimits <$> parseJSON value

instance ToJSON EnginesWithLimits where toJSON (EnginesWithLimits value) = toJSON value
