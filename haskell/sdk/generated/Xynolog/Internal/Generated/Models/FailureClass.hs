-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FailureClass (FailureClass (..), failureClassText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data FailureClass = FailureClassTransient | FailureClassDeterministic | FailureClassWithheld deriving (Eq, Show)

instance FromJSON FailureClass where parseJSON = checked "FailureClass" $ \value -> if value == String "transient" then pure FailureClassTransient else if value == String "deterministic" then pure FailureClassDeterministic else if value == String "withheld" then pure FailureClassWithheld else fail "unknown enumeration member"

instance ToJSON FailureClass where
  toJSON FailureClassTransient = String "transient"
  toJSON FailureClassDeterministic = String "deterministic"
  toJSON FailureClassWithheld = String "withheld"

failureClassText :: FailureClass -> Text
failureClassText FailureClassTransient = "transient"
failureClassText FailureClassDeterministic = "deterministic"
failureClassText FailureClassWithheld = "withheld"
