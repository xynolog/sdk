-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbEndpoint (KbEndpoint (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HttpEndpoint
import Xynolog.Internal.Generated.Models.LocalEndpoint

data KbEndpoint = KbEndpointHttpEndpoint HttpEndpoint | KbEndpointLocalEndpoint LocalEndpoint deriving (Eq, Show)

instance FromJSON KbEndpoint where parseJSON = checked "KbEndpoint" $ \value -> (KbEndpointHttpEndpoint <$> parseJSON value) <|> (KbEndpointLocalEndpoint <$> parseJSON value)

instance ToJSON KbEndpoint where
  toJSON (KbEndpointHttpEndpoint value) = toJSON value
  toJSON (KbEndpointLocalEndpoint value) = toJSON value
