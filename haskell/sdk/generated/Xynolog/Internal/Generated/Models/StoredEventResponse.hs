-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StoredEventResponse (StoredEventResponse (..), StoredEventResponsePayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.EventMetadata
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data StoredEventResponse = StoredEventResponse
  { storedEventResponseId :: Text,
    storedEventResponseType :: Text,
    storedEventResponseTimestamp :: Text,
    storedEventResponseUserId :: UserId,
    storedEventResponseResourceId :: Maybe ResourceId,
    storedEventResponseVersion :: Integer,
    storedEventResponsePayload :: StoredEventResponsePayload,
    storedEventResponseMetadata :: EventMetadata
  }
  deriving (Eq, Show)

instance FromJSON StoredEventResponse where parseJSON = checked "StoredEventResponse" $ withObject "StoredEventResponse" (\fields -> StoredEventResponse <$> (fields .: "id") <*> (fields .: "type") <*> (fields .: "timestamp") <*> (fields .: "userId") <*> optional fields "resourceId" <*> (fields .: "version") <*> (fields .: "payload") <*> (fields .: "metadata"))

instance ToJSON StoredEventResponse where toJSON value = Object (KM.fromList (concat [[("id", toJSON (storedEventResponseId value))], [("type", toJSON (storedEventResponseType value))], [("timestamp", toJSON (storedEventResponseTimestamp value))], [("userId", toJSON (storedEventResponseUserId value))], optionalPair "resourceId" (storedEventResponseResourceId value), [("version", toJSON (storedEventResponseVersion value))], [("payload", toJSON (storedEventResponsePayload value))], [("metadata", toJSON (storedEventResponseMetadata value))]]))

data StoredEventResponsePayload = StoredEventResponsePayload
  { storedEventResponsePayloadAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON StoredEventResponsePayload where parseJSON = checked "StoredEventResponsePayload" $ withObject "StoredEventResponsePayload" (\fields -> StoredEventResponsePayload <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON StoredEventResponsePayload where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (storedEventResponsePayloadAdditionalProperties value)))
