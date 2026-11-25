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
  { attributedEventAgent :: Agent,
    attributedEventId :: Text,
    attributedEventMetadata :: EventMetadata,
    attributedEventPayload :: StoredEventResponsePayload,
    attributedEventResourceId :: Maybe ResourceId,
    attributedEventTimestamp :: Text,
    attributedEventType :: Text,
    attributedEventUserId :: UserId,
    attributedEventVersion :: Integer
  }
  deriving (Eq, Show)

instance FromJSON AttributedEvent where parseJSON = checked "AttributedEvent" $ withObject "AttributedEvent" (\fields -> AttributedEvent <$> (fields .: "agent") <*> (fields .: "id") <*> (fields .: "metadata") <*> (fields .: "payload") <*> optional fields "resourceId" <*> (fields .: "timestamp") <*> (fields .: "type") <*> (fields .: "userId") <*> (fields .: "version"))

instance ToJSON AttributedEvent where toJSON value = Object (KM.fromList (concat [[("agent", toJSON (attributedEventAgent value))], [("id", toJSON (attributedEventId value))], [("metadata", toJSON (attributedEventMetadata value))], [("payload", toJSON (attributedEventPayload value))], optionalPair "resourceId" (attributedEventResourceId value), [("timestamp", toJSON (attributedEventTimestamp value))], [("type", toJSON (attributedEventType value))], [("userId", toJSON (attributedEventUserId value))], [("version", toJSON (attributedEventVersion value))]]))
