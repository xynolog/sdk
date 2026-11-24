-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RequestId (RequestId (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data RequestId = RequestIdBranch1 Text | RequestIdBranch2 Integer deriving (Eq, Show)

instance FromJSON RequestId where parseJSON = checked "RequestId" $ \value -> (RequestIdBranch1 <$> parseJSON value) <|> (RequestIdBranch2 <$> parseJSON value)

instance ToJSON RequestId where
  toJSON (RequestIdBranch1 value) = toJSON value
  toJSON (RequestIdBranch2 value) = toJSON value
