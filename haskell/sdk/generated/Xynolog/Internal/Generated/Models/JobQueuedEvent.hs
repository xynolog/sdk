-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobQueuedEvent (JobQueuedEvent (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MarkJobQueuedEvent
import Xynolog.Internal.Generated.Models.YieldJobQueuedEvent

data JobQueuedEvent = JobQueuedEventMarkJobQueuedEvent MarkJobQueuedEvent | JobQueuedEventYieldJobQueuedEvent YieldJobQueuedEvent deriving (Eq, Show)

instance FromJSON JobQueuedEvent where parseJSON = checked "JobQueuedEvent" $ \value -> (JobQueuedEventMarkJobQueuedEvent <$> parseJSON value) <|> (JobQueuedEventYieldJobQueuedEvent <$> parseJSON value)

instance ToJSON JobQueuedEvent where
  toJSON (JobQueuedEventMarkJobQueuedEvent value) = toJSON value
  toJSON (JobQueuedEventYieldJobQueuedEvent value) = toJSON value
