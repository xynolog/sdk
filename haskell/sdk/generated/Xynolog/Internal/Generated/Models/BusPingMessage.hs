-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BusPingMessage (BusPingMessage (..), BusPingMessageEvent (..), busPingMessageEventText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data BusPingMessage = BusPingMessage
  { busPingMessageData :: Text,
    busPingMessageEvent :: BusPingMessageEvent
  }
  deriving (Eq, Show)

instance FromJSON BusPingMessage where parseJSON = checked "BusPingMessage" $ withObject "BusPingMessage" (\fields -> BusPingMessage <$> (fields .: "data") <*> (fields .: "event"))

instance ToJSON BusPingMessage where toJSON value = Object (KM.fromList (concat [[("data", toJSON (busPingMessageData value))], [("event", toJSON (busPingMessageEvent value))]]))

data BusPingMessageEvent = BusPingMessageEventPing deriving (Eq, Show)

instance FromJSON BusPingMessageEvent where parseJSON = checked "BusPingMessageEvent" $ \value -> if value == String "ping" then pure BusPingMessageEventPing else fail "unknown enumeration member"

instance ToJSON BusPingMessageEvent where toJSON BusPingMessageEventPing = String "ping"

busPingMessageEventText :: BusPingMessageEvent -> Text
busPingMessageEventText BusPingMessageEventPing = "ping"
