-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AttributedEvent (AttributedEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Agent
import Xynolog.Internal.Generated.Models.EventMetadata
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.StoredEventResponse
import Xynolog.Internal.Generated.Models.UserId

data AttributedEvent = AttributedEvent
  { attributedEventId :: Text,
    attributedEventType :: Text,
    attributedEventTimestamp :: Text,
    attributedEventUserId :: UserId,
    attributedEventResourceId :: Maybe ResourceId,
    attributedEventVersion :: Integer,
    attributedEventPayload :: StoredEventResponsePayload,
    attributedEventMetadata :: EventMetadata,
    attributedEventAgent :: Agent
  }
  deriving (Eq, Show)

instance FromJSON AttributedEvent where parseJSON = checked "AttributedEvent" $ withObject "AttributedEvent" (\fields -> AttributedEvent <$> (fields .: "id") <*> (fields .: "type") <*> (fields .: "timestamp") <*> (fields .: "userId") <*> optional fields "resourceId" <*> (fields .: "version") <*> (fields .: "payload") <*> (fields .: "metadata") <*> (fields .: "agent"))

instance ToJSON AttributedEvent where toJSON value = Object (KM.fromList (concat [[("id", toJSON (attributedEventId value))], [("type", toJSON (attributedEventType value))], [("timestamp", toJSON (attributedEventTimestamp value))], [("userId", toJSON (attributedEventUserId value))], optionalPair "resourceId" (attributedEventResourceId value), [("version", toJSON (attributedEventVersion value))], [("payload", toJSON (attributedEventPayload value))], [("metadata", toJSON (attributedEventMetadata value))], [("agent", toJSON (attributedEventAgent value))]]))
