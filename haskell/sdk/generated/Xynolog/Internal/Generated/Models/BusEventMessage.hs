-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BusEventMessage (BusEventMessage (..), BusEventMessageEvent (..), busEventMessageEventText, BusEventMessageId (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.BusFrame
import Xynolog.Internal.Generated.Models.EphemeralEventId
import Xynolog.Internal.Generated.Models.PersistedEventId
import Xynolog.Internal.Generated.Models.ReplyEventId

data BusEventMessage = BusEventMessage
  { busEventMessageData :: BusFrame,
    busEventMessageEvent :: BusEventMessageEvent,
    busEventMessageId :: BusEventMessageId
  }
  deriving (Eq, Show)

instance FromJSON BusEventMessage where parseJSON = checked "BusEventMessage" $ withObject "BusEventMessage" (\fields -> BusEventMessage <$> (fields .: "data") <*> (fields .: "event") <*> (fields .: "id"))

instance ToJSON BusEventMessage where toJSON value = Object (KM.fromList (concat [[("data", toJSON (busEventMessageData value))], [("event", toJSON (busEventMessageEvent value))], [("id", toJSON (busEventMessageId value))]]))

data BusEventMessageEvent = BusEventMessageEventBusEvent deriving (Eq, Show)

instance FromJSON BusEventMessageEvent where parseJSON = checked "BusEventMessageEvent" $ \value -> if value == String "bus-event" then pure BusEventMessageEventBusEvent else fail "unknown enumeration member"

instance ToJSON BusEventMessageEvent where toJSON BusEventMessageEventBusEvent = String "bus-event"

busEventMessageEventText :: BusEventMessageEvent -> Text
busEventMessageEventText BusEventMessageEventBusEvent = "bus-event"

data BusEventMessageId = BusEventMessageIdPersistedEventId PersistedEventId | BusEventMessageIdReplyEventId ReplyEventId | BusEventMessageIdEphemeralEventId EphemeralEventId deriving (Eq, Show)

instance FromJSON BusEventMessageId where parseJSON = checked "BusEventMessageId" $ \value -> (BusEventMessageIdPersistedEventId <$> parseJSON value) <|> (BusEventMessageIdReplyEventId <$> parseJSON value) <|> (BusEventMessageIdEphemeralEventId <$> parseJSON value)

instance ToJSON BusEventMessageId where
  toJSON (BusEventMessageIdPersistedEventId value) = toJSON value
  toJSON (BusEventMessageIdReplyEventId value) = toJSON value
  toJSON (BusEventMessageIdEphemeralEventId value) = toJSON value
