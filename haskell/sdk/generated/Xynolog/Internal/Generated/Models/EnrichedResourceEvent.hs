-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.EnrichedResourceEvent (EnrichedResourceEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Annotation
import Xynolog.Internal.Generated.Models.EventMetadata
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.StoredEventResponse
import Xynolog.Internal.Generated.Models.UserId

data EnrichedResourceEvent = EnrichedResourceEvent
  { enrichedResourceEventAnnotation :: Maybe Annotation,
    enrichedResourceEventId :: Text,
    enrichedResourceEventMetadata :: EventMetadata,
    enrichedResourceEventPayload :: StoredEventResponsePayload,
    enrichedResourceEventResourceId :: Maybe ResourceId,
    enrichedResourceEventTimestamp :: Text,
    enrichedResourceEventType :: Text,
    enrichedResourceEventUserId :: UserId,
    enrichedResourceEventVersion :: Integer
  }
  deriving (Eq, Show)

instance FromJSON EnrichedResourceEvent where parseJSON = checked "EnrichedResourceEvent" $ withObject "EnrichedResourceEvent" (\fields -> EnrichedResourceEvent <$> optional fields "annotation" <*> (fields .: "id") <*> (fields .: "metadata") <*> (fields .: "payload") <*> optional fields "resourceId" <*> (fields .: "timestamp") <*> (fields .: "type") <*> (fields .: "userId") <*> (fields .: "version"))

instance ToJSON EnrichedResourceEvent where toJSON value = Object (KM.fromList (concat [optionalPair "annotation" (enrichedResourceEventAnnotation value), [("id", toJSON (enrichedResourceEventId value))], [("metadata", toJSON (enrichedResourceEventMetadata value))], [("payload", toJSON (enrichedResourceEventPayload value))], optionalPair "resourceId" (enrichedResourceEventResourceId value), [("timestamp", toJSON (enrichedResourceEventTimestamp value))], [("type", toJSON (enrichedResourceEventType value))], [("userId", toJSON (enrichedResourceEventUserId value))], [("version", toJSON (enrichedResourceEventVersion value))]]))
