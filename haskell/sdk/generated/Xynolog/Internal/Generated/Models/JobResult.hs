-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobResult (JobResult (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobDeclined
import Xynolog.Internal.Generated.Models.MarkJobDone
import Xynolog.Internal.Generated.Models.YieldJobDone

data JobResult = JobResultMarkJobDone MarkJobDone | JobResultYieldJobDone YieldJobDone | JobResultJobDeclined JobDeclined deriving (Eq, Show)

instance FromJSON JobResult where parseJSON = checked "JobResult" $ \value -> (JobResultMarkJobDone <$> parseJSON value) <|> (JobResultYieldJobDone <$> parseJSON value) <|> (JobResultJobDeclined <$> parseJSON value)

instance ToJSON JobResult where
  toJSON (JobResultMarkJobDone value) = toJSON value
  toJSON (JobResultYieldJobDone value) = toJSON value
  toJSON (JobResultJobDeclined value) = toJSON value
