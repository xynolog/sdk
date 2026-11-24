-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobStoredProgress (JobStoredProgress (..), JobStoredProgressObjectValue (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobProgress

data JobStoredProgress = JobStoredProgressJobProgress JobProgress | JobStoredProgressObject JobStoredProgressObjectValue deriving (Eq, Show)

instance FromJSON JobStoredProgress where parseJSON = checked "JobStoredProgress" $ \value -> (JobStoredProgressJobProgress <$> parseJSON value) <|> (JobStoredProgressObject <$> parseJSON value)

instance ToJSON JobStoredProgress where
  toJSON (JobStoredProgressJobProgress value) = toJSON value
  toJSON (JobStoredProgressObject value) = toJSON value

data JobStoredProgressObjectValue = JobStoredProgressObjectValue
  { jobStoredProgressObjectValueAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON JobStoredProgressObjectValue where parseJSON = checked "JobStoredProgressObjectValue" $ withObject "JobStoredProgressObjectValue" (\fields -> JobStoredProgressObjectValue <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobStoredProgressObjectValue where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobStoredProgressObjectValueAdditionalProperties value)))
