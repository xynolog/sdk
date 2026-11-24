-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RequestId (RequestId (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data RequestId = RequestIdText Text | RequestIdInteger Integer deriving (Eq, Show)

instance FromJSON RequestId where parseJSON = checked "RequestId" $ \value -> (RequestIdText <$> parseJSON value) <|> (RequestIdInteger <$> parseJSON value)

instance ToJSON RequestId where
  toJSON (RequestIdText value) = toJSON value
  toJSON (RequestIdInteger value) = toJSON value
