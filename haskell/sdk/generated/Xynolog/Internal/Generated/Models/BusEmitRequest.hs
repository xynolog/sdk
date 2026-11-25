-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BusEmitRequest (BusEmitRequest (..), BusEmitRequestPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data BusEmitRequest = BusEmitRequest
  { busEmitRequestChannel :: Text,
    busEmitRequestPayload :: BusEmitRequestPayload,
    busEmitRequestScope :: Maybe ResourceId,
    busEmitRequestClientId :: Maybe Text,
    busEmitRequestCorrelationId :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON BusEmitRequest where parseJSON = checked "BusEmitRequest" $ withObject "BusEmitRequest" (\fields -> BusEmitRequest <$> (fields .: "channel") <*> (fields .: "payload") <*> optional fields "scope" <*> optional fields "clientId" <*> optional fields "correlationId")

instance ToJSON BusEmitRequest where toJSON value = Object (KM.fromList (concat [[("channel", toJSON (busEmitRequestChannel value))], [("payload", toJSON (busEmitRequestPayload value))], optionalPair "scope" (busEmitRequestScope value), optionalPair "clientId" (busEmitRequestClientId value), optionalPair "correlationId" (busEmitRequestCorrelationId value)]))

data BusEmitRequestPayload = BusEmitRequestPayload
  { busEmitRequestPayloadAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON BusEmitRequestPayload where parseJSON = checked "BusEmitRequestPayload" $ withObject "BusEmitRequestPayload" (\fields -> BusEmitRequestPayload <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON BusEmitRequestPayload where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (busEmitRequestPayloadAdditionalProperties value)))
