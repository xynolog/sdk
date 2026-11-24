-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobCreateCommand (JobCreateCommand (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MarkJobCreateCommand
import Xynolog.Internal.Generated.Models.YieldJobCreateCommand

data JobCreateCommand = JobCreateCommandMarkJobCreateCommand MarkJobCreateCommand | JobCreateCommandYieldJobCreateCommand YieldJobCreateCommand deriving (Eq, Show)

instance FromJSON JobCreateCommand where parseJSON = checked "JobCreateCommand" $ \value -> (JobCreateCommandMarkJobCreateCommand <$> parseJSON value) <|> (JobCreateCommandYieldJobCreateCommand <$> parseJSON value)

instance ToJSON JobCreateCommand where
  toJSON (JobCreateCommandMarkJobCreateCommand value) = toJSON value
  toJSON (JobCreateCommandYieldJobCreateCommand value) = toJSON value
