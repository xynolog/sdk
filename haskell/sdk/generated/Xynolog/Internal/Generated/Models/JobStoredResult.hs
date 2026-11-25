-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobStoredResult (JobStoredResult (..), JobStoredResultEmpty (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobResult

data JobStoredResult = JobStoredResultJobResult JobResult | JobStoredResultEmpty JobStoredResultEmpty deriving (Eq, Show)

instance FromJSON JobStoredResult where parseJSON = checked "JobStoredResult" $ \value -> (JobStoredResultJobResult <$> parseJSON value) <|> (JobStoredResultEmpty <$> parseJSON value)

instance ToJSON JobStoredResult where
  toJSON (JobStoredResultJobResult value) = toJSON value
  toJSON (JobStoredResultEmpty value) = toJSON value

data JobStoredResultEmpty = MkJobStoredResultEmpty
  { jobStoredResultEmptyAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobStoredResultEmpty where parseJSON = checked "JobStoredResultEmpty" $ withObject "JobStoredResultEmpty" (\fields -> MkJobStoredResultEmpty <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobStoredResultEmpty where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobStoredResultEmptyAdditionalProperties value)))
