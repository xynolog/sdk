-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BusEventMessage (BusEventMessage (..), BusEventMessageEvent (..), busEventMessageEventText, BusEventMessageId (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.BusFrame
import Xynolog.Internal.Generated.Models.EphemeralEventId
import Xynolog.Internal.Generated.Models.PersistedEventId
import Xynolog.Internal.Generated.Models.ReplyEventId

data BusEventMessage = BusEventMessage
  { busEventMessageEvent :: BusEventMessageEvent,
    busEventMessageId :: BusEventMessageId,
    busEventMessageData :: BusFrame
  }
  deriving (Eq, Show)

instance FromJSON BusEventMessage where parseJSON = checked "BusEventMessage" $ withObject "BusEventMessage" (\fields -> BusEventMessage <$> (fields .: "event") <*> (fields .: "id") <*> (fields .: "data"))

instance ToJSON BusEventMessage where toJSON value = Object (KM.fromList (concat [[("event", toJSON (busEventMessageEvent value))], [("id", toJSON (busEventMessageId value))], [("data", toJSON (busEventMessageData value))]]))

data BusEventMessageEvent = BusEventMessageEventBusEvent deriving (Eq, Show)

instance FromJSON BusEventMessageEvent where parseJSON = checked "BusEventMessageEvent" $ \value -> if value == String "bus-event" then pure BusEventMessageEventBusEvent else fail "unknown enumeration member"

instance ToJSON BusEventMessageEvent where toJSON BusEventMessageEventBusEvent = String "bus-event"

busEventMessageEventText :: BusEventMessageEvent -> Text
busEventMessageEventText BusEventMessageEventBusEvent = "bus-event"

data BusEventMessageId = BusEventMessageIdPersistedEventId PersistedEventId | BusEventMessageIdReplyEventId ReplyEventId | BusEventMessageIdEphemeralEventId EphemeralEventId deriving (Eq, Show)

instance FromJSON BusEventMessageId where parseJSON = checked "BusEventMessageId" $ \value -> readMember "BusEventMessageId" [([Signature {signatureKind = TextKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Just "^p-.+-[0-9]+$", signatureValues = Nothing}], BusEventMessageIdPersistedEventId <$> parseJSON value), ([Signature {signatureKind = TextKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Just "^e-[^:]+:[^:]+:.+$", signatureValues = Nothing}], BusEventMessageIdReplyEventId <$> parseJSON value), ([Signature {signatureKind = TextKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Just "^e-[^:]+$", signatureValues = Nothing}], BusEventMessageIdEphemeralEventId <$> parseJSON value)] value

instance ToJSON BusEventMessageId where
  toJSON (BusEventMessageIdPersistedEventId value) = toJSON value
  toJSON (BusEventMessageIdReplyEventId value) = toJSON value
  toJSON (BusEventMessageIdEphemeralEventId value) = toJSON value
