-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RetryBudget (RetryBudget (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data RetryBudget = RetryBudget
  { retryBudgetAttempts :: Integer,
    retryBudgetInitialDelayMs :: Integer,
    retryBudgetMaxDelayMs :: Integer
  }
  deriving (Eq, Show)

instance FromJSON RetryBudget where parseJSON = checked "RetryBudget" $ withObject "RetryBudget" (\fields -> RetryBudget <$> (fields .: "attempts") <*> (fields .: "initialDelayMs") <*> (fields .: "maxDelayMs"))

instance ToJSON RetryBudget where toJSON value = Object (KM.fromList (concat [[("attempts", toJSON (retryBudgetAttempts value))], [("initialDelayMs", toJSON (retryBudgetInitialDelayMs value))], [("maxDelayMs", toJSON (retryBudgetMaxDelayMs value))]]))
