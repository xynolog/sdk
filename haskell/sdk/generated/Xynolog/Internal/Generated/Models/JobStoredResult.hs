-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobStoredResult (JobStoredResult (..), JobStoredResultObjectValue (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobResult

data JobStoredResult = JobStoredResultJobResult JobResult | JobStoredResultObject JobStoredResultObjectValue deriving (Eq, Show)

instance FromJSON JobStoredResult where parseJSON = checked "JobStoredResult" $ \value -> (JobStoredResultJobResult <$> parseJSON value) <|> (JobStoredResultObject <$> parseJSON value)

instance ToJSON JobStoredResult where
  toJSON (JobStoredResultJobResult value) = toJSON value
  toJSON (JobStoredResultObject value) = toJSON value

data JobStoredResultObjectValue = JobStoredResultObjectValue
  { jobStoredResultObjectValueAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobStoredResultObjectValue where parseJSON = checked "JobStoredResultObjectValue" $ withObject "JobStoredResultObjectValue" (\fields -> JobStoredResultObjectValue <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobStoredResultObjectValue where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobStoredResultObjectValueAdditionalProperties value)))
