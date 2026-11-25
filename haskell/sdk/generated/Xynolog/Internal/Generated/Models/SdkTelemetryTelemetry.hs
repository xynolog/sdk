-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SdkTelemetryTelemetry (SdkTelemetryTelemetry (..), SdkTelemetryTelemetryMetricsItem (..), SdkTelemetryTelemetryMetricsItemAttributesItem (..), SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem (..), SdkTelemetryTelemetryMetricsItemInstrument (..), sdkTelemetryTelemetryMetricsItemInstrumentText, SdkTelemetryTelemetryMetricsItemTransport (..), sdkTelemetryTelemetryMetricsItemTransportText, SdkTelemetryTelemetrySpansItem (..), SdkTelemetryTelemetrySpansItemAttributesItem (..), SdkTelemetryTelemetrySpansItemAttributesItemValuesItem (..), SdkTelemetryTelemetrySpansItemKind (..), sdkTelemetryTelemetrySpansItemKindText, SdkTelemetryTelemetrySpansItemTransport (..), sdkTelemetryTelemetrySpansItemTransportText) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SdkTelemetryTelemetry = SdkTelemetryTelemetry
  { sdkTelemetryTelemetryComment :: Text,
    sdkTelemetryTelemetrySpans :: [SdkTelemetryTelemetrySpansItem],
    sdkTelemetryTelemetryMetrics :: [SdkTelemetryTelemetryMetricsItem]
  }
  deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetry where parseJSON = checked "SdkTelemetryTelemetry" $ withObject "SdkTelemetryTelemetry" (\fields -> SdkTelemetryTelemetry <$> (fields .: "$comment") <*> (fields .: "spans") <*> (fields .: "metrics"))

instance ToJSON SdkTelemetryTelemetry where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (sdkTelemetryTelemetryComment value))], [("spans", toJSON (sdkTelemetryTelemetrySpans value))], [("metrics", toJSON (sdkTelemetryTelemetryMetrics value))]]))

data SdkTelemetryTelemetryMetricsItem = SdkTelemetryTelemetryMetricsItem
  { sdkTelemetryTelemetryMetricsItemName :: Text,
    sdkTelemetryTelemetryMetricsItemTransport :: SdkTelemetryTelemetryMetricsItemTransport,
    sdkTelemetryTelemetryMetricsItemInstrument :: SdkTelemetryTelemetryMetricsItemInstrument,
    sdkTelemetryTelemetryMetricsItemMeaning :: Text,
    sdkTelemetryTelemetryMetricsItemAttributes :: [SdkTelemetryTelemetryMetricsItemAttributesItem]
  }
  deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetryMetricsItem where parseJSON = checked "SdkTelemetryTelemetryMetricsItem" $ withObject "SdkTelemetryTelemetryMetricsItem" (\fields -> SdkTelemetryTelemetryMetricsItem <$> (fields .: "name") <*> (fields .: "transport") <*> (fields .: "instrument") <*> (fields .: "meaning") <*> (fields .: "attributes"))

instance ToJSON SdkTelemetryTelemetryMetricsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (sdkTelemetryTelemetryMetricsItemName value))], [("transport", toJSON (sdkTelemetryTelemetryMetricsItemTransport value))], [("instrument", toJSON (sdkTelemetryTelemetryMetricsItemInstrument value))], [("meaning", toJSON (sdkTelemetryTelemetryMetricsItemMeaning value))], [("attributes", toJSON (sdkTelemetryTelemetryMetricsItemAttributes value))]]))

data SdkTelemetryTelemetryMetricsItemAttributesItem = SdkTelemetryTelemetryMetricsItemAttributesItem
  { sdkTelemetryTelemetryMetricsItemAttributesItemKey :: Text,
    sdkTelemetryTelemetryMetricsItemAttributesItemOnly :: Maybe Text,
    sdkTelemetryTelemetryMetricsItemAttributesItemValues :: Maybe [SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem]
  }
  deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetryMetricsItemAttributesItem where parseJSON = checked "SdkTelemetryTelemetryMetricsItemAttributesItem" $ withObject "SdkTelemetryTelemetryMetricsItemAttributesItem" (\fields -> SdkTelemetryTelemetryMetricsItemAttributesItem <$> (fields .: "key") <*> optional fields "only" <*> optional fields "values")

instance ToJSON SdkTelemetryTelemetryMetricsItemAttributesItem where toJSON value = Object (KM.fromList (concat [[("key", toJSON (sdkTelemetryTelemetryMetricsItemAttributesItemKey value))], optionalPair "only" (sdkTelemetryTelemetryMetricsItemAttributesItemOnly value), optionalPair "values" (sdkTelemetryTelemetryMetricsItemAttributesItemValues value)]))

data SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem = SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText Text | SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean Bool deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem where parseJSON = checked "SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem" $ \value -> (SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText <$> parseJSON value) <|> (SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean <$> parseJSON value)

instance ToJSON SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem where
  toJSON (SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText value) = toJSON value
  toJSON (SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean value) = toJSON value

data SdkTelemetryTelemetryMetricsItemInstrument = SdkTelemetryTelemetryMetricsItemInstrumentCounter | SdkTelemetryTelemetryMetricsItemInstrumentUpDownCounter | SdkTelemetryTelemetryMetricsItemInstrumentGauge | SdkTelemetryTelemetryMetricsItemInstrumentHistogram deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetryMetricsItemInstrument where parseJSON = checked "SdkTelemetryTelemetryMetricsItemInstrument" $ \value -> if value == String "counter" then pure SdkTelemetryTelemetryMetricsItemInstrumentCounter else if value == String "up-down counter" then pure SdkTelemetryTelemetryMetricsItemInstrumentUpDownCounter else if value == String "gauge" then pure SdkTelemetryTelemetryMetricsItemInstrumentGauge else if value == String "histogram" then pure SdkTelemetryTelemetryMetricsItemInstrumentHistogram else fail "unknown enumeration member"

instance ToJSON SdkTelemetryTelemetryMetricsItemInstrument where
  toJSON SdkTelemetryTelemetryMetricsItemInstrumentCounter = String "counter"
  toJSON SdkTelemetryTelemetryMetricsItemInstrumentUpDownCounter = String "up-down counter"
  toJSON SdkTelemetryTelemetryMetricsItemInstrumentGauge = String "gauge"
  toJSON SdkTelemetryTelemetryMetricsItemInstrumentHistogram = String "histogram"

sdkTelemetryTelemetryMetricsItemInstrumentText :: SdkTelemetryTelemetryMetricsItemInstrument -> Text
sdkTelemetryTelemetryMetricsItemInstrumentText SdkTelemetryTelemetryMetricsItemInstrumentCounter = "counter"
sdkTelemetryTelemetryMetricsItemInstrumentText SdkTelemetryTelemetryMetricsItemInstrumentUpDownCounter = "up-down counter"
sdkTelemetryTelemetryMetricsItemInstrumentText SdkTelemetryTelemetryMetricsItemInstrumentGauge = "gauge"
sdkTelemetryTelemetryMetricsItemInstrumentText SdkTelemetryTelemetryMetricsItemInstrumentHistogram = "histogram"

data SdkTelemetryTelemetryMetricsItemTransport = SdkTelemetryTelemetryMetricsItemTransportBus | SdkTelemetryTelemetryMetricsItemTransportContent deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetryMetricsItemTransport where parseJSON = checked "SdkTelemetryTelemetryMetricsItemTransport" $ \value -> if value == String "bus" then pure SdkTelemetryTelemetryMetricsItemTransportBus else if value == String "content" then pure SdkTelemetryTelemetryMetricsItemTransportContent else fail "unknown enumeration member"

instance ToJSON SdkTelemetryTelemetryMetricsItemTransport where
  toJSON SdkTelemetryTelemetryMetricsItemTransportBus = String "bus"
  toJSON SdkTelemetryTelemetryMetricsItemTransportContent = String "content"

sdkTelemetryTelemetryMetricsItemTransportText :: SdkTelemetryTelemetryMetricsItemTransport -> Text
sdkTelemetryTelemetryMetricsItemTransportText SdkTelemetryTelemetryMetricsItemTransportBus = "bus"
sdkTelemetryTelemetryMetricsItemTransportText SdkTelemetryTelemetryMetricsItemTransportContent = "content"

data SdkTelemetryTelemetrySpansItem = SdkTelemetryTelemetrySpansItem
  { sdkTelemetryTelemetrySpansItemName :: Text,
    sdkTelemetryTelemetrySpansItemTransport :: SdkTelemetryTelemetrySpansItemTransport,
    sdkTelemetryTelemetrySpansItemKind :: SdkTelemetryTelemetrySpansItemKind,
    sdkTelemetryTelemetrySpansItemMeaning :: Text,
    sdkTelemetryTelemetrySpansItemAttributes :: [SdkTelemetryTelemetrySpansItemAttributesItem]
  }
  deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetrySpansItem where parseJSON = checked "SdkTelemetryTelemetrySpansItem" $ withObject "SdkTelemetryTelemetrySpansItem" (\fields -> SdkTelemetryTelemetrySpansItem <$> (fields .: "name") <*> (fields .: "transport") <*> (fields .: "kind") <*> (fields .: "meaning") <*> (fields .: "attributes"))

instance ToJSON SdkTelemetryTelemetrySpansItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (sdkTelemetryTelemetrySpansItemName value))], [("transport", toJSON (sdkTelemetryTelemetrySpansItemTransport value))], [("kind", toJSON (sdkTelemetryTelemetrySpansItemKind value))], [("meaning", toJSON (sdkTelemetryTelemetrySpansItemMeaning value))], [("attributes", toJSON (sdkTelemetryTelemetrySpansItemAttributes value))]]))

data SdkTelemetryTelemetrySpansItemAttributesItem = SdkTelemetryTelemetrySpansItemAttributesItem
  { sdkTelemetryTelemetrySpansItemAttributesItemKey :: Text,
    sdkTelemetryTelemetrySpansItemAttributesItemOnly :: Maybe Text,
    sdkTelemetryTelemetrySpansItemAttributesItemValues :: Maybe [SdkTelemetryTelemetrySpansItemAttributesItemValuesItem]
  }
  deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetrySpansItemAttributesItem where parseJSON = checked "SdkTelemetryTelemetrySpansItemAttributesItem" $ withObject "SdkTelemetryTelemetrySpansItemAttributesItem" (\fields -> SdkTelemetryTelemetrySpansItemAttributesItem <$> (fields .: "key") <*> optional fields "only" <*> optional fields "values")

instance ToJSON SdkTelemetryTelemetrySpansItemAttributesItem where toJSON value = Object (KM.fromList (concat [[("key", toJSON (sdkTelemetryTelemetrySpansItemAttributesItemKey value))], optionalPair "only" (sdkTelemetryTelemetrySpansItemAttributesItemOnly value), optionalPair "values" (sdkTelemetryTelemetrySpansItemAttributesItemValues value)]))

data SdkTelemetryTelemetrySpansItemAttributesItemValuesItem = SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText Text | SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean Bool deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetrySpansItemAttributesItemValuesItem where parseJSON = checked "SdkTelemetryTelemetrySpansItemAttributesItemValuesItem" $ \value -> (SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText <$> parseJSON value) <|> (SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean <$> parseJSON value)

instance ToJSON SdkTelemetryTelemetrySpansItemAttributesItemValuesItem where
  toJSON (SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText value) = toJSON value
  toJSON (SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean value) = toJSON value

data SdkTelemetryTelemetrySpansItemKind = SdkTelemetryTelemetrySpansItemKindClient | SdkTelemetryTelemetrySpansItemKindConsumer | SdkTelemetryTelemetrySpansItemKindInternal | SdkTelemetryTelemetrySpansItemKindProducer | SdkTelemetryTelemetrySpansItemKindServer deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetrySpansItemKind where parseJSON = checked "SdkTelemetryTelemetrySpansItemKind" $ \value -> if value == String "client" then pure SdkTelemetryTelemetrySpansItemKindClient else if value == String "consumer" then pure SdkTelemetryTelemetrySpansItemKindConsumer else if value == String "internal" then pure SdkTelemetryTelemetrySpansItemKindInternal else if value == String "producer" then pure SdkTelemetryTelemetrySpansItemKindProducer else if value == String "server" then pure SdkTelemetryTelemetrySpansItemKindServer else fail "unknown enumeration member"

instance ToJSON SdkTelemetryTelemetrySpansItemKind where
  toJSON SdkTelemetryTelemetrySpansItemKindClient = String "client"
  toJSON SdkTelemetryTelemetrySpansItemKindConsumer = String "consumer"
  toJSON SdkTelemetryTelemetrySpansItemKindInternal = String "internal"
  toJSON SdkTelemetryTelemetrySpansItemKindProducer = String "producer"
  toJSON SdkTelemetryTelemetrySpansItemKindServer = String "server"

sdkTelemetryTelemetrySpansItemKindText :: SdkTelemetryTelemetrySpansItemKind -> Text
sdkTelemetryTelemetrySpansItemKindText SdkTelemetryTelemetrySpansItemKindClient = "client"
sdkTelemetryTelemetrySpansItemKindText SdkTelemetryTelemetrySpansItemKindConsumer = "consumer"
sdkTelemetryTelemetrySpansItemKindText SdkTelemetryTelemetrySpansItemKindInternal = "internal"
sdkTelemetryTelemetrySpansItemKindText SdkTelemetryTelemetrySpansItemKindProducer = "producer"
sdkTelemetryTelemetrySpansItemKindText SdkTelemetryTelemetrySpansItemKindServer = "server"

data SdkTelemetryTelemetrySpansItemTransport = SdkTelemetryTelemetrySpansItemTransportBus | SdkTelemetryTelemetrySpansItemTransportContent deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetrySpansItemTransport where parseJSON = checked "SdkTelemetryTelemetrySpansItemTransport" $ \value -> if value == String "bus" then pure SdkTelemetryTelemetrySpansItemTransportBus else if value == String "content" then pure SdkTelemetryTelemetrySpansItemTransportContent else fail "unknown enumeration member"

instance ToJSON SdkTelemetryTelemetrySpansItemTransport where
  toJSON SdkTelemetryTelemetrySpansItemTransportBus = String "bus"
  toJSON SdkTelemetryTelemetrySpansItemTransportContent = String "content"

sdkTelemetryTelemetrySpansItemTransportText :: SdkTelemetryTelemetrySpansItemTransport -> Text
sdkTelemetryTelemetrySpansItemTransportText SdkTelemetryTelemetrySpansItemTransportBus = "bus"
sdkTelemetryTelemetrySpansItemTransportText SdkTelemetryTelemetrySpansItemTransportContent = "content"
