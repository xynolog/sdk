-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkJobResult (MarkJobResult (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobDeclined
import Xynolog.Internal.Generated.Models.MarkJobDone

data MarkJobResult = MarkJobResultMarkJobDone MarkJobDone | MarkJobResultJobDeclined JobDeclined deriving (Eq, Show)

instance FromJSON MarkJobResult where parseJSON = checked "MarkJobResult" $ \value -> (MarkJobResultMarkJobDone <$> parseJSON value) <|> (MarkJobResultJobDeclined <$> parseJSON value)

instance ToJSON MarkJobResult where
  toJSON (MarkJobResultMarkJobDone value) = toJSON value
  toJSON (MarkJobResultJobDeclined value) = toJSON value
