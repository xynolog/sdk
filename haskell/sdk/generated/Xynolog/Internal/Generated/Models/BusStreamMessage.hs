-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BusStreamMessage (BusStreamMessage (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.BusEventMessage
import Xynolog.Internal.Generated.Models.BusPingMessage

data BusStreamMessage = BusStreamMessageBusEventMessage BusEventMessage | BusStreamMessageBusPingMessage BusPingMessage deriving (Eq, Show)

instance FromJSON BusStreamMessage where parseJSON = checked "BusStreamMessage" $ \value -> readMember "BusStreamMessage" [([Signature {signatureKind = ObjectKind, signatureRequired = ["event", "id", "data"], signatureAllowed = Just ["event", "id", "data"], signatureFixed = [("event", [String "bus-event"])], signaturePattern = Nothing, signatureValues = Nothing}], BusStreamMessageBusEventMessage <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["event", "data"], signatureAllowed = Just ["event", "data"], signatureFixed = [("event", [String "ping"])], signaturePattern = Nothing, signatureValues = Nothing}], BusStreamMessageBusPingMessage <$> parseJSON value)] value

instance ToJSON BusStreamMessage where
  toJSON (BusStreamMessageBusEventMessage value) = toJSON value
  toJSON (BusStreamMessageBusPingMessage value) = toJSON value
