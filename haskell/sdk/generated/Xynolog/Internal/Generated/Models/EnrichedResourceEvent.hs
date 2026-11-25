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
  { enrichedResourceEventId :: Text,
    enrichedResourceEventType :: Text,
    enrichedResourceEventTimestamp :: Text,
    enrichedResourceEventUserId :: UserId,
    enrichedResourceEventResourceId :: Maybe ResourceId,
    enrichedResourceEventVersion :: Integer,
    enrichedResourceEventPayload :: StoredEventResponsePayload,
    enrichedResourceEventMetadata :: EventMetadata,
    enrichedResourceEventAnnotation :: Maybe Annotation
  }
  deriving (Eq, Show)

instance FromJSON EnrichedResourceEvent where parseJSON = checked "EnrichedResourceEvent" $ withObject "EnrichedResourceEvent" (\fields -> EnrichedResourceEvent <$> (fields .: "id") <*> (fields .: "type") <*> (fields .: "timestamp") <*> (fields .: "userId") <*> optional fields "resourceId" <*> (fields .: "version") <*> (fields .: "payload") <*> (fields .: "metadata") <*> optional fields "annotation")

instance ToJSON EnrichedResourceEvent where toJSON value = Object (KM.fromList (concat [[("id", toJSON (enrichedResourceEventId value))], [("type", toJSON (enrichedResourceEventType value))], [("timestamp", toJSON (enrichedResourceEventTimestamp value))], [("userId", toJSON (enrichedResourceEventUserId value))], optionalPair "resourceId" (enrichedResourceEventResourceId value), [("version", toJSON (enrichedResourceEventVersion value))], [("payload", toJSON (enrichedResourceEventPayload value))], [("metadata", toJSON (enrichedResourceEventMetadata value))], optionalPair "annotation" (enrichedResourceEventAnnotation value)]))
