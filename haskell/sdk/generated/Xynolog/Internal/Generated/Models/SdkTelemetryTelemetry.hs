-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SdkTelemetryTelemetry (SdkTelemetryTelemetry (..), SdkTelemetryTelemetryMetricsItem (..), SdkTelemetryTelemetryMetricsItemAttributesItem (..), SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem (..), SdkTelemetryTelemetrySpansItem (..), SdkTelemetryTelemetrySpansItemAttributesItem (..), SdkTelemetryTelemetrySpansItemAttributesItemValuesItem (..), SdkTelemetryTelemetrySpansItemTransport (..), sdkTelemetryTelemetrySpansItemTransportText, ServiceTelemetryTelemetryMetricsItemInstrument (..), serviceTelemetryTelemetryMetricsItemInstrumentText, ServiceTelemetryTelemetrySpansItemKind (..), serviceTelemetryTelemetrySpansItemKindText) where

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
    sdkTelemetryTelemetryMetricsItemTransport :: SdkTelemetryTelemetrySpansItemTransport,
    sdkTelemetryTelemetryMetricsItemInstrument :: ServiceTelemetryTelemetryMetricsItemInstrument,
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

instance FromJSON SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem where parseJSON = checked "SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem" $ \value -> readMember "SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem" [([Signature {signatureKind = TextKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText <$> parseJSON value), ([Signature {signatureKind = BooleanKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean <$> parseJSON value)] value

instance ToJSON SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem where
  toJSON (SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText value) = toJSON value
  toJSON (SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean value) = toJSON value

data SdkTelemetryTelemetrySpansItem = SdkTelemetryTelemetrySpansItem
  { sdkTelemetryTelemetrySpansItemName :: Text,
    sdkTelemetryTelemetrySpansItemTransport :: SdkTelemetryTelemetrySpansItemTransport,
    sdkTelemetryTelemetrySpansItemKind :: ServiceTelemetryTelemetrySpansItemKind,
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

instance FromJSON SdkTelemetryTelemetrySpansItemAttributesItemValuesItem where parseJSON = checked "SdkTelemetryTelemetrySpansItemAttributesItemValuesItem" $ \value -> readMember "SdkTelemetryTelemetrySpansItemAttributesItemValuesItem" [([Signature {signatureKind = TextKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText <$> parseJSON value), ([Signature {signatureKind = BooleanKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean <$> parseJSON value)] value

instance ToJSON SdkTelemetryTelemetrySpansItemAttributesItemValuesItem where
  toJSON (SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText value) = toJSON value
  toJSON (SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean value) = toJSON value

data SdkTelemetryTelemetrySpansItemTransport = SdkTelemetryTelemetrySpansItemTransportBus | SdkTelemetryTelemetrySpansItemTransportContent deriving (Eq, Show)

instance FromJSON SdkTelemetryTelemetrySpansItemTransport where parseJSON = checked "SdkTelemetryTelemetrySpansItemTransport" $ \value -> if value == String "bus" then pure SdkTelemetryTelemetrySpansItemTransportBus else if value == String "content" then pure SdkTelemetryTelemetrySpansItemTransportContent else fail "unknown enumeration member"

instance ToJSON SdkTelemetryTelemetrySpansItemTransport where
  toJSON SdkTelemetryTelemetrySpansItemTransportBus = String "bus"
  toJSON SdkTelemetryTelemetrySpansItemTransportContent = String "content"

sdkTelemetryTelemetrySpansItemTransportText :: SdkTelemetryTelemetrySpansItemTransport -> Text
sdkTelemetryTelemetrySpansItemTransportText SdkTelemetryTelemetrySpansItemTransportBus = "bus"
sdkTelemetryTelemetrySpansItemTransportText SdkTelemetryTelemetrySpansItemTransportContent = "content"

data ServiceTelemetryTelemetryMetricsItemInstrument = ServiceTelemetryTelemetryMetricsItemInstrumentCounter | ServiceTelemetryTelemetryMetricsItemInstrumentUpDownCounter | ServiceTelemetryTelemetryMetricsItemInstrumentGauge | ServiceTelemetryTelemetryMetricsItemInstrumentHistogram deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryMetricsItemInstrument where parseJSON = checked "ServiceTelemetryTelemetryMetricsItemInstrument" $ \value -> if value == String "counter" then pure ServiceTelemetryTelemetryMetricsItemInstrumentCounter else if value == String "up-down counter" then pure ServiceTelemetryTelemetryMetricsItemInstrumentUpDownCounter else if value == String "gauge" then pure ServiceTelemetryTelemetryMetricsItemInstrumentGauge else if value == String "histogram" then pure ServiceTelemetryTelemetryMetricsItemInstrumentHistogram else fail "unknown enumeration member"

instance ToJSON ServiceTelemetryTelemetryMetricsItemInstrument where
  toJSON ServiceTelemetryTelemetryMetricsItemInstrumentCounter = String "counter"
  toJSON ServiceTelemetryTelemetryMetricsItemInstrumentUpDownCounter = String "up-down counter"
  toJSON ServiceTelemetryTelemetryMetricsItemInstrumentGauge = String "gauge"
  toJSON ServiceTelemetryTelemetryMetricsItemInstrumentHistogram = String "histogram"

serviceTelemetryTelemetryMetricsItemInstrumentText :: ServiceTelemetryTelemetryMetricsItemInstrument -> Text
serviceTelemetryTelemetryMetricsItemInstrumentText ServiceTelemetryTelemetryMetricsItemInstrumentCounter = "counter"
serviceTelemetryTelemetryMetricsItemInstrumentText ServiceTelemetryTelemetryMetricsItemInstrumentUpDownCounter = "up-down counter"
serviceTelemetryTelemetryMetricsItemInstrumentText ServiceTelemetryTelemetryMetricsItemInstrumentGauge = "gauge"
serviceTelemetryTelemetryMetricsItemInstrumentText ServiceTelemetryTelemetryMetricsItemInstrumentHistogram = "histogram"

data ServiceTelemetryTelemetrySpansItemKind = ServiceTelemetryTelemetrySpansItemKindClient | ServiceTelemetryTelemetrySpansItemKindConsumer | ServiceTelemetryTelemetrySpansItemKindInternal | ServiceTelemetryTelemetrySpansItemKindProducer | ServiceTelemetryTelemetrySpansItemKindServer deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetrySpansItemKind where parseJSON = checked "ServiceTelemetryTelemetrySpansItemKind" $ \value -> if value == String "client" then pure ServiceTelemetryTelemetrySpansItemKindClient else if value == String "consumer" then pure ServiceTelemetryTelemetrySpansItemKindConsumer else if value == String "internal" then pure ServiceTelemetryTelemetrySpansItemKindInternal else if value == String "producer" then pure ServiceTelemetryTelemetrySpansItemKindProducer else if value == String "server" then pure ServiceTelemetryTelemetrySpansItemKindServer else fail "unknown enumeration member"

instance ToJSON ServiceTelemetryTelemetrySpansItemKind where
  toJSON ServiceTelemetryTelemetrySpansItemKindClient = String "client"
  toJSON ServiceTelemetryTelemetrySpansItemKindConsumer = String "consumer"
  toJSON ServiceTelemetryTelemetrySpansItemKindInternal = String "internal"
  toJSON ServiceTelemetryTelemetrySpansItemKindProducer = String "producer"
  toJSON ServiceTelemetryTelemetrySpansItemKindServer = String "server"

serviceTelemetryTelemetrySpansItemKindText :: ServiceTelemetryTelemetrySpansItemKind -> Text
serviceTelemetryTelemetrySpansItemKindText ServiceTelemetryTelemetrySpansItemKindClient = "client"
serviceTelemetryTelemetrySpansItemKindText ServiceTelemetryTelemetrySpansItemKindConsumer = "consumer"
serviceTelemetryTelemetrySpansItemKindText ServiceTelemetryTelemetrySpansItemKindInternal = "internal"
serviceTelemetryTelemetrySpansItemKindText ServiceTelemetryTelemetrySpansItemKindProducer = "producer"
serviceTelemetryTelemetrySpansItemKindText ServiceTelemetryTelemetrySpansItemKindServer = "server"
