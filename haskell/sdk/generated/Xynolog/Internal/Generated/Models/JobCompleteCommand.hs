-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobCompleteCommand (JobCompleteCommand (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MarkJobCompleteCommand
import Xynolog.Internal.Generated.Models.YieldJobCompleteCommand

data JobCompleteCommand = JobCompleteCommandMarkJobCompleteCommand MarkJobCompleteCommand | JobCompleteCommandYieldJobCompleteCommand YieldJobCompleteCommand deriving (Eq, Show)

instance FromJSON JobCompleteCommand where parseJSON = checked "JobCompleteCommand" $ \value -> (JobCompleteCommandMarkJobCompleteCommand <$> parseJSON value) <|> (JobCompleteCommandYieldJobCompleteCommand <$> parseJSON value)

instance ToJSON JobCompleteCommand where
  toJSON (JobCompleteCommandMarkJobCompleteCommand value) = toJSON value
  toJSON (JobCompleteCommandYieldJobCompleteCommand value) = toJSON value
