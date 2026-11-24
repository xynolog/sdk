-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldJobResult (YieldJobResult (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobDeclined
import Xynolog.Internal.Generated.Models.YieldJobDone

data YieldJobResult = YieldJobResultYieldJobDone YieldJobDone | YieldJobResultJobDeclined JobDeclined deriving (Eq, Show)

instance FromJSON YieldJobResult where parseJSON = checked "YieldJobResult" $ \value -> (YieldJobResultYieldJobDone <$> parseJSON value) <|> (YieldJobResultJobDeclined <$> parseJSON value)

instance ToJSON YieldJobResult where
  toJSON (YieldJobResultYieldJobDone value) = toJSON value
  toJSON (YieldJobResultJobDeclined value) = toJSON value
