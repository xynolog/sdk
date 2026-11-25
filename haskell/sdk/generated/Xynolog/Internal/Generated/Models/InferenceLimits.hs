-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.InferenceLimits (InferenceLimits (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec

data InferenceLimits = InferenceLimits
  { inferenceLimitsAcceptsTemperature :: Maybe Bool,
    inferenceLimitsContextTokens :: Scientific,
    inferenceLimitsMaxOutputTokens :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON InferenceLimits where parseJSON = checked "InferenceLimits" $ withObject "InferenceLimits" (\fields -> InferenceLimits <$> optional fields "acceptsTemperature" <*> (fields .: "contextTokens") <*> (fields .: "maxOutputTokens"))

instance ToJSON InferenceLimits where toJSON value = Object (KM.fromList (concat [optionalPair "acceptsTemperature" (inferenceLimitsAcceptsTemperature value), [("contextTokens", toJSON (inferenceLimitsContextTokens value))], [("maxOutputTokens", toJSON (inferenceLimitsMaxOutputTokens value))]]))
