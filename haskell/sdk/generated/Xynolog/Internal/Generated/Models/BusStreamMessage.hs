-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BusStreamMessage (BusStreamMessage (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.BusEventMessage
import Xynolog.Internal.Generated.Models.BusPingMessage

data BusStreamMessage = BusStreamMessageBusEventMessage BusEventMessage | BusStreamMessageBusPingMessage BusPingMessage deriving (Eq, Show)

instance FromJSON BusStreamMessage where parseJSON = checked "BusStreamMessage" $ \value -> (BusStreamMessageBusEventMessage <$> parseJSON value) <|> (BusStreamMessageBusPingMessage <$> parseJSON value)

instance ToJSON BusStreamMessage where
  toJSON (BusStreamMessageBusEventMessage value) = toJSON value
  toJSON (BusStreamMessageBusPingMessage value) = toJSON value
