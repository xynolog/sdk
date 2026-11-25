-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceTelemetryTelemetry (ServiceTelemetryTelemetry (..), ServiceTelemetryTelemetryMetricsItem (..), ServiceTelemetryTelemetryMetricsItemAttributesItem (..), ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem (..), ServiceTelemetryTelemetryMetricsItemInstrument (..), serviceTelemetryTelemetryMetricsItemInstrumentText, ServiceTelemetryTelemetryMetricsItemPlanesItem (..), serviceTelemetryTelemetryMetricsItemPlanesItemText, ServiceTelemetryTelemetryMetricsItemServicesItem (..), serviceTelemetryTelemetryMetricsItemServicesItemText, ServiceTelemetryTelemetryMetricsItemWhen (..), serviceTelemetryTelemetryMetricsItemWhenText, ServiceTelemetryTelemetryResourceItem (..), ServiceTelemetryTelemetryResourceItemServicesItem (..), serviceTelemetryTelemetryResourceItemServicesItemText, ServiceTelemetryTelemetrySdk (..), ServiceTelemetryTelemetrySpansItem (..), ServiceTelemetryTelemetrySpansItemAttributesItem (..), ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem (..), ServiceTelemetryTelemetrySpansItemKind (..), serviceTelemetryTelemetrySpansItemKindText, ServiceTelemetryTelemetrySpansItemServicesItem (..), serviceTelemetryTelemetrySpansItemServicesItemText, ServiceTelemetryTelemetrySpansItemWhen (..), serviceTelemetryTelemetrySpansItemWhenText) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ServiceTelemetryTelemetry = ServiceTelemetryTelemetry
  { serviceTelemetryTelemetryComment :: Text,
    serviceTelemetryTelemetryMetrics :: [ServiceTelemetryTelemetryMetricsItem],
    serviceTelemetryTelemetryResource :: [ServiceTelemetryTelemetryResourceItem],
    serviceTelemetryTelemetrySdk :: ServiceTelemetryTelemetrySdk,
    serviceTelemetryTelemetrySpans :: [ServiceTelemetryTelemetrySpansItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetry where parseJSON = checked "ServiceTelemetryTelemetry" $ withObject "ServiceTelemetryTelemetry" (\fields -> ServiceTelemetryTelemetry <$> (fields .: "$comment") <*> (fields .: "metrics") <*> (fields .: "resource") <*> (fields .: "sdk") <*> (fields .: "spans"))

instance ToJSON ServiceTelemetryTelemetry where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (serviceTelemetryTelemetryComment value))], [("metrics", toJSON (serviceTelemetryTelemetryMetrics value))], [("resource", toJSON (serviceTelemetryTelemetryResource value))], [("sdk", toJSON (serviceTelemetryTelemetrySdk value))], [("spans", toJSON (serviceTelemetryTelemetrySpans value))]]))

data ServiceTelemetryTelemetryMetricsItem = ServiceTelemetryTelemetryMetricsItem
  { serviceTelemetryTelemetryMetricsItemAttributes :: [ServiceTelemetryTelemetryMetricsItemAttributesItem],
    serviceTelemetryTelemetryMetricsItemInstrument :: ServiceTelemetryTelemetryMetricsItemInstrument,
    serviceTelemetryTelemetryMetricsItemMeaning :: Text,
    serviceTelemetryTelemetryMetricsItemName :: Text,
    serviceTelemetryTelemetryMetricsItemPlanes :: Maybe [ServiceTelemetryTelemetryMetricsItemPlanesItem],
    serviceTelemetryTelemetryMetricsItemServices :: [ServiceTelemetryTelemetryMetricsItemServicesItem],
    serviceTelemetryTelemetryMetricsItemWhen :: ServiceTelemetryTelemetryMetricsItemWhen
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryMetricsItem where parseJSON = checked "ServiceTelemetryTelemetryMetricsItem" $ withObject "ServiceTelemetryTelemetryMetricsItem" (\fields -> ServiceTelemetryTelemetryMetricsItem <$> (fields .: "attributes") <*> (fields .: "instrument") <*> (fields .: "meaning") <*> (fields .: "name") <*> optional fields "planes" <*> (fields .: "services") <*> (fields .: "when"))

instance ToJSON ServiceTelemetryTelemetryMetricsItem where toJSON value = Object (KM.fromList (concat [[("attributes", toJSON (serviceTelemetryTelemetryMetricsItemAttributes value))], [("instrument", toJSON (serviceTelemetryTelemetryMetricsItemInstrument value))], [("meaning", toJSON (serviceTelemetryTelemetryMetricsItemMeaning value))], [("name", toJSON (serviceTelemetryTelemetryMetricsItemName value))], optionalPair "planes" (serviceTelemetryTelemetryMetricsItemPlanes value), [("services", toJSON (serviceTelemetryTelemetryMetricsItemServices value))], [("when", toJSON (serviceTelemetryTelemetryMetricsItemWhen value))]]))

data ServiceTelemetryTelemetryMetricsItemAttributesItem = ServiceTelemetryTelemetryMetricsItemAttributesItem
  { serviceTelemetryTelemetryMetricsItemAttributesItemKey :: Text,
    serviceTelemetryTelemetryMetricsItemAttributesItemOnly :: Maybe Text,
    serviceTelemetryTelemetryMetricsItemAttributesItemValues :: Maybe [ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryMetricsItemAttributesItem where parseJSON = checked "ServiceTelemetryTelemetryMetricsItemAttributesItem" $ withObject "ServiceTelemetryTelemetryMetricsItemAttributesItem" (\fields -> ServiceTelemetryTelemetryMetricsItemAttributesItem <$> (fields .: "key") <*> optional fields "only" <*> optional fields "values")

instance ToJSON ServiceTelemetryTelemetryMetricsItemAttributesItem where toJSON value = Object (KM.fromList (concat [[("key", toJSON (serviceTelemetryTelemetryMetricsItemAttributesItemKey value))], optionalPair "only" (serviceTelemetryTelemetryMetricsItemAttributesItemOnly value), optionalPair "values" (serviceTelemetryTelemetryMetricsItemAttributesItemValues value)]))

data ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem = ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText Text | ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean Bool deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem where parseJSON = checked "ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem" $ \value -> (ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText <$> parseJSON value) <|> (ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean <$> parseJSON value)

instance ToJSON ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem where
  toJSON (ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText value) = toJSON value
  toJSON (ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean value) = toJSON value

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

data ServiceTelemetryTelemetryMetricsItemPlanesItem = ServiceTelemetryTelemetryMetricsItemPlanesItemInProcess | ServiceTelemetryTelemetryMetricsItemPlanesItemNats deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryMetricsItemPlanesItem where parseJSON = checked "ServiceTelemetryTelemetryMetricsItemPlanesItem" $ \value -> if value == String "in-process" then pure ServiceTelemetryTelemetryMetricsItemPlanesItemInProcess else if value == String "nats" then pure ServiceTelemetryTelemetryMetricsItemPlanesItemNats else fail "unknown enumeration member"

instance ToJSON ServiceTelemetryTelemetryMetricsItemPlanesItem where
  toJSON ServiceTelemetryTelemetryMetricsItemPlanesItemInProcess = String "in-process"
  toJSON ServiceTelemetryTelemetryMetricsItemPlanesItemNats = String "nats"

serviceTelemetryTelemetryMetricsItemPlanesItemText :: ServiceTelemetryTelemetryMetricsItemPlanesItem -> Text
serviceTelemetryTelemetryMetricsItemPlanesItemText ServiceTelemetryTelemetryMetricsItemPlanesItemInProcess = "in-process"
serviceTelemetryTelemetryMetricsItemPlanesItemText ServiceTelemetryTelemetryMetricsItemPlanesItemNats = "nats"

data ServiceTelemetryTelemetryMetricsItemServicesItem = ServiceTelemetryTelemetryMetricsItemServicesItemArchivist | ServiceTelemetryTelemetryMetricsItemServicesItemDispatcher | ServiceTelemetryTelemetryMetricsItemServicesItemGateway | ServiceTelemetryTelemetryMetricsItemServicesItemLibrarian | ServiceTelemetryTelemetryMetricsItemServicesItemSmelter | ServiceTelemetryTelemetryMetricsItemServicesItemWeaver | ServiceTelemetryTelemetryMetricsItemServicesItemWorker deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryMetricsItemServicesItem where parseJSON = checked "ServiceTelemetryTelemetryMetricsItemServicesItem" $ \value -> if value == String "archivist" then pure ServiceTelemetryTelemetryMetricsItemServicesItemArchivist else if value == String "dispatcher" then pure ServiceTelemetryTelemetryMetricsItemServicesItemDispatcher else if value == String "gateway" then pure ServiceTelemetryTelemetryMetricsItemServicesItemGateway else if value == String "librarian" then pure ServiceTelemetryTelemetryMetricsItemServicesItemLibrarian else if value == String "smelter" then pure ServiceTelemetryTelemetryMetricsItemServicesItemSmelter else if value == String "weaver" then pure ServiceTelemetryTelemetryMetricsItemServicesItemWeaver else if value == String "worker" then pure ServiceTelemetryTelemetryMetricsItemServicesItemWorker else fail "unknown enumeration member"

instance ToJSON ServiceTelemetryTelemetryMetricsItemServicesItem where
  toJSON ServiceTelemetryTelemetryMetricsItemServicesItemArchivist = String "archivist"
  toJSON ServiceTelemetryTelemetryMetricsItemServicesItemDispatcher = String "dispatcher"
  toJSON ServiceTelemetryTelemetryMetricsItemServicesItemGateway = String "gateway"
  toJSON ServiceTelemetryTelemetryMetricsItemServicesItemLibrarian = String "librarian"
  toJSON ServiceTelemetryTelemetryMetricsItemServicesItemSmelter = String "smelter"
  toJSON ServiceTelemetryTelemetryMetricsItemServicesItemWeaver = String "weaver"
  toJSON ServiceTelemetryTelemetryMetricsItemServicesItemWorker = String "worker"

serviceTelemetryTelemetryMetricsItemServicesItemText :: ServiceTelemetryTelemetryMetricsItemServicesItem -> Text
serviceTelemetryTelemetryMetricsItemServicesItemText ServiceTelemetryTelemetryMetricsItemServicesItemArchivist = "archivist"
serviceTelemetryTelemetryMetricsItemServicesItemText ServiceTelemetryTelemetryMetricsItemServicesItemDispatcher = "dispatcher"
serviceTelemetryTelemetryMetricsItemServicesItemText ServiceTelemetryTelemetryMetricsItemServicesItemGateway = "gateway"
serviceTelemetryTelemetryMetricsItemServicesItemText ServiceTelemetryTelemetryMetricsItemServicesItemLibrarian = "librarian"
serviceTelemetryTelemetryMetricsItemServicesItemText ServiceTelemetryTelemetryMetricsItemServicesItemSmelter = "smelter"
serviceTelemetryTelemetryMetricsItemServicesItemText ServiceTelemetryTelemetryMetricsItemServicesItemWeaver = "weaver"
serviceTelemetryTelemetryMetricsItemServicesItemText ServiceTelemetryTelemetryMetricsItemServicesItemWorker = "worker"

data ServiceTelemetryTelemetryMetricsItemWhen = ServiceTelemetryTelemetryMetricsItemWhenExport | ServiceTelemetryTelemetryMetricsItemWhenTraffic | ServiceTelemetryTelemetryMetricsItemWhenSupervised | ServiceTelemetryTelemetryMetricsItemWhenFatal deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryMetricsItemWhen where parseJSON = checked "ServiceTelemetryTelemetryMetricsItemWhen" $ \value -> if value == String "export" then pure ServiceTelemetryTelemetryMetricsItemWhenExport else if value == String "traffic" then pure ServiceTelemetryTelemetryMetricsItemWhenTraffic else if value == String "supervised" then pure ServiceTelemetryTelemetryMetricsItemWhenSupervised else if value == String "fatal" then pure ServiceTelemetryTelemetryMetricsItemWhenFatal else fail "unknown enumeration member"

instance ToJSON ServiceTelemetryTelemetryMetricsItemWhen where
  toJSON ServiceTelemetryTelemetryMetricsItemWhenExport = String "export"
  toJSON ServiceTelemetryTelemetryMetricsItemWhenTraffic = String "traffic"
  toJSON ServiceTelemetryTelemetryMetricsItemWhenSupervised = String "supervised"
  toJSON ServiceTelemetryTelemetryMetricsItemWhenFatal = String "fatal"

serviceTelemetryTelemetryMetricsItemWhenText :: ServiceTelemetryTelemetryMetricsItemWhen -> Text
serviceTelemetryTelemetryMetricsItemWhenText ServiceTelemetryTelemetryMetricsItemWhenExport = "export"
serviceTelemetryTelemetryMetricsItemWhenText ServiceTelemetryTelemetryMetricsItemWhenTraffic = "traffic"
serviceTelemetryTelemetryMetricsItemWhenText ServiceTelemetryTelemetryMetricsItemWhenSupervised = "supervised"
serviceTelemetryTelemetryMetricsItemWhenText ServiceTelemetryTelemetryMetricsItemWhenFatal = "fatal"

data ServiceTelemetryTelemetryResourceItem = ServiceTelemetryTelemetryResourceItem
  { serviceTelemetryTelemetryResourceItemDefault :: Maybe Text,
    serviceTelemetryTelemetryResourceItemKey :: Text,
    serviceTelemetryTelemetryResourceItemMeaning :: Text,
    serviceTelemetryTelemetryResourceItemServices :: [ServiceTelemetryTelemetryResourceItemServicesItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryResourceItem where parseJSON = checked "ServiceTelemetryTelemetryResourceItem" $ withObject "ServiceTelemetryTelemetryResourceItem" (\fields -> ServiceTelemetryTelemetryResourceItem <$> optional fields "default" <*> (fields .: "key") <*> (fields .: "meaning") <*> (fields .: "services"))

instance ToJSON ServiceTelemetryTelemetryResourceItem where toJSON value = Object (KM.fromList (concat [optionalPair "default" (serviceTelemetryTelemetryResourceItemDefault value), [("key", toJSON (serviceTelemetryTelemetryResourceItemKey value))], [("meaning", toJSON (serviceTelemetryTelemetryResourceItemMeaning value))], [("services", toJSON (serviceTelemetryTelemetryResourceItemServices value))]]))

data ServiceTelemetryTelemetryResourceItemServicesItem = ServiceTelemetryTelemetryResourceItemServicesItemArchivist | ServiceTelemetryTelemetryResourceItemServicesItemDispatcher | ServiceTelemetryTelemetryResourceItemServicesItemGateway | ServiceTelemetryTelemetryResourceItemServicesItemLibrarian | ServiceTelemetryTelemetryResourceItemServicesItemSmelter | ServiceTelemetryTelemetryResourceItemServicesItemWeaver | ServiceTelemetryTelemetryResourceItemServicesItemWorker deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryResourceItemServicesItem where parseJSON = checked "ServiceTelemetryTelemetryResourceItemServicesItem" $ \value -> if value == String "archivist" then pure ServiceTelemetryTelemetryResourceItemServicesItemArchivist else if value == String "dispatcher" then pure ServiceTelemetryTelemetryResourceItemServicesItemDispatcher else if value == String "gateway" then pure ServiceTelemetryTelemetryResourceItemServicesItemGateway else if value == String "librarian" then pure ServiceTelemetryTelemetryResourceItemServicesItemLibrarian else if value == String "smelter" then pure ServiceTelemetryTelemetryResourceItemServicesItemSmelter else if value == String "weaver" then pure ServiceTelemetryTelemetryResourceItemServicesItemWeaver else if value == String "worker" then pure ServiceTelemetryTelemetryResourceItemServicesItemWorker else fail "unknown enumeration member"

instance ToJSON ServiceTelemetryTelemetryResourceItemServicesItem where
  toJSON ServiceTelemetryTelemetryResourceItemServicesItemArchivist = String "archivist"
  toJSON ServiceTelemetryTelemetryResourceItemServicesItemDispatcher = String "dispatcher"
  toJSON ServiceTelemetryTelemetryResourceItemServicesItemGateway = String "gateway"
  toJSON ServiceTelemetryTelemetryResourceItemServicesItemLibrarian = String "librarian"
  toJSON ServiceTelemetryTelemetryResourceItemServicesItemSmelter = String "smelter"
  toJSON ServiceTelemetryTelemetryResourceItemServicesItemWeaver = String "weaver"
  toJSON ServiceTelemetryTelemetryResourceItemServicesItemWorker = String "worker"

serviceTelemetryTelemetryResourceItemServicesItemText :: ServiceTelemetryTelemetryResourceItemServicesItem -> Text
serviceTelemetryTelemetryResourceItemServicesItemText ServiceTelemetryTelemetryResourceItemServicesItemArchivist = "archivist"
serviceTelemetryTelemetryResourceItemServicesItemText ServiceTelemetryTelemetryResourceItemServicesItemDispatcher = "dispatcher"
serviceTelemetryTelemetryResourceItemServicesItemText ServiceTelemetryTelemetryResourceItemServicesItemGateway = "gateway"
serviceTelemetryTelemetryResourceItemServicesItemText ServiceTelemetryTelemetryResourceItemServicesItemLibrarian = "librarian"
serviceTelemetryTelemetryResourceItemServicesItemText ServiceTelemetryTelemetryResourceItemServicesItemSmelter = "smelter"
serviceTelemetryTelemetryResourceItemServicesItemText ServiceTelemetryTelemetryResourceItemServicesItemWeaver = "weaver"
serviceTelemetryTelemetryResourceItemServicesItemText ServiceTelemetryTelemetryResourceItemServicesItemWorker = "worker"

data ServiceTelemetryTelemetrySdk = ServiceTelemetryTelemetrySdk
  { serviceTelemetryTelemetrySdkAdditionalProperties :: KM.KeyMap [Text]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetrySdk where parseJSON = checked "ServiceTelemetryTelemetrySdk" $ withObject "ServiceTelemetryTelemetrySdk" (\fields -> ServiceTelemetryTelemetrySdk <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ServiceTelemetryTelemetrySdk where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (serviceTelemetryTelemetrySdkAdditionalProperties value)))

data ServiceTelemetryTelemetrySpansItem = ServiceTelemetryTelemetrySpansItem
  { serviceTelemetryTelemetrySpansItemAttributes :: [ServiceTelemetryTelemetrySpansItemAttributesItem],
    serviceTelemetryTelemetrySpansItemKind :: ServiceTelemetryTelemetrySpansItemKind,
    serviceTelemetryTelemetrySpansItemMeaning :: Text,
    serviceTelemetryTelemetrySpansItemName :: Text,
    serviceTelemetryTelemetrySpansItemServices :: [ServiceTelemetryTelemetrySpansItemServicesItem],
    serviceTelemetryTelemetrySpansItemWhen :: ServiceTelemetryTelemetrySpansItemWhen
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetrySpansItem where parseJSON = checked "ServiceTelemetryTelemetrySpansItem" $ withObject "ServiceTelemetryTelemetrySpansItem" (\fields -> ServiceTelemetryTelemetrySpansItem <$> (fields .: "attributes") <*> (fields .: "kind") <*> (fields .: "meaning") <*> (fields .: "name") <*> (fields .: "services") <*> (fields .: "when"))

instance ToJSON ServiceTelemetryTelemetrySpansItem where toJSON value = Object (KM.fromList (concat [[("attributes", toJSON (serviceTelemetryTelemetrySpansItemAttributes value))], [("kind", toJSON (serviceTelemetryTelemetrySpansItemKind value))], [("meaning", toJSON (serviceTelemetryTelemetrySpansItemMeaning value))], [("name", toJSON (serviceTelemetryTelemetrySpansItemName value))], [("services", toJSON (serviceTelemetryTelemetrySpansItemServices value))], [("when", toJSON (serviceTelemetryTelemetrySpansItemWhen value))]]))

data ServiceTelemetryTelemetrySpansItemAttributesItem = ServiceTelemetryTelemetrySpansItemAttributesItem
  { serviceTelemetryTelemetrySpansItemAttributesItemKey :: Text,
    serviceTelemetryTelemetrySpansItemAttributesItemOnly :: Maybe Text,
    serviceTelemetryTelemetrySpansItemAttributesItemValues :: Maybe [ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetrySpansItemAttributesItem where parseJSON = checked "ServiceTelemetryTelemetrySpansItemAttributesItem" $ withObject "ServiceTelemetryTelemetrySpansItemAttributesItem" (\fields -> ServiceTelemetryTelemetrySpansItemAttributesItem <$> (fields .: "key") <*> optional fields "only" <*> optional fields "values")

instance ToJSON ServiceTelemetryTelemetrySpansItemAttributesItem where toJSON value = Object (KM.fromList (concat [[("key", toJSON (serviceTelemetryTelemetrySpansItemAttributesItemKey value))], optionalPair "only" (serviceTelemetryTelemetrySpansItemAttributesItemOnly value), optionalPair "values" (serviceTelemetryTelemetrySpansItemAttributesItemValues value)]))

data ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem = ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText Text | ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean Bool deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem where parseJSON = checked "ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem" $ \value -> (ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText <$> parseJSON value) <|> (ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean <$> parseJSON value)

instance ToJSON ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem where
  toJSON (ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText value) = toJSON value
  toJSON (ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean value) = toJSON value

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

data ServiceTelemetryTelemetrySpansItemServicesItem = ServiceTelemetryTelemetrySpansItemServicesItemArchivist | ServiceTelemetryTelemetrySpansItemServicesItemDispatcher | ServiceTelemetryTelemetrySpansItemServicesItemGateway | ServiceTelemetryTelemetrySpansItemServicesItemLibrarian | ServiceTelemetryTelemetrySpansItemServicesItemSmelter | ServiceTelemetryTelemetrySpansItemServicesItemWeaver | ServiceTelemetryTelemetrySpansItemServicesItemWorker deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetrySpansItemServicesItem where parseJSON = checked "ServiceTelemetryTelemetrySpansItemServicesItem" $ \value -> if value == String "archivist" then pure ServiceTelemetryTelemetrySpansItemServicesItemArchivist else if value == String "dispatcher" then pure ServiceTelemetryTelemetrySpansItemServicesItemDispatcher else if value == String "gateway" then pure ServiceTelemetryTelemetrySpansItemServicesItemGateway else if value == String "librarian" then pure ServiceTelemetryTelemetrySpansItemServicesItemLibrarian else if value == String "smelter" then pure ServiceTelemetryTelemetrySpansItemServicesItemSmelter else if value == String "weaver" then pure ServiceTelemetryTelemetrySpansItemServicesItemWeaver else if value == String "worker" then pure ServiceTelemetryTelemetrySpansItemServicesItemWorker else fail "unknown enumeration member"

instance ToJSON ServiceTelemetryTelemetrySpansItemServicesItem where
  toJSON ServiceTelemetryTelemetrySpansItemServicesItemArchivist = String "archivist"
  toJSON ServiceTelemetryTelemetrySpansItemServicesItemDispatcher = String "dispatcher"
  toJSON ServiceTelemetryTelemetrySpansItemServicesItemGateway = String "gateway"
  toJSON ServiceTelemetryTelemetrySpansItemServicesItemLibrarian = String "librarian"
  toJSON ServiceTelemetryTelemetrySpansItemServicesItemSmelter = String "smelter"
  toJSON ServiceTelemetryTelemetrySpansItemServicesItemWeaver = String "weaver"
  toJSON ServiceTelemetryTelemetrySpansItemServicesItemWorker = String "worker"

serviceTelemetryTelemetrySpansItemServicesItemText :: ServiceTelemetryTelemetrySpansItemServicesItem -> Text
serviceTelemetryTelemetrySpansItemServicesItemText ServiceTelemetryTelemetrySpansItemServicesItemArchivist = "archivist"
serviceTelemetryTelemetrySpansItemServicesItemText ServiceTelemetryTelemetrySpansItemServicesItemDispatcher = "dispatcher"
serviceTelemetryTelemetrySpansItemServicesItemText ServiceTelemetryTelemetrySpansItemServicesItemGateway = "gateway"
serviceTelemetryTelemetrySpansItemServicesItemText ServiceTelemetryTelemetrySpansItemServicesItemLibrarian = "librarian"
serviceTelemetryTelemetrySpansItemServicesItemText ServiceTelemetryTelemetrySpansItemServicesItemSmelter = "smelter"
serviceTelemetryTelemetrySpansItemServicesItemText ServiceTelemetryTelemetrySpansItemServicesItemWeaver = "weaver"
serviceTelemetryTelemetrySpansItemServicesItemText ServiceTelemetryTelemetrySpansItemServicesItemWorker = "worker"

data ServiceTelemetryTelemetrySpansItemWhen = ServiceTelemetryTelemetrySpansItemWhenExport | ServiceTelemetryTelemetrySpansItemWhenTraffic | ServiceTelemetryTelemetrySpansItemWhenSupervised | ServiceTelemetryTelemetrySpansItemWhenFatal deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetrySpansItemWhen where parseJSON = checked "ServiceTelemetryTelemetrySpansItemWhen" $ \value -> if value == String "export" then pure ServiceTelemetryTelemetrySpansItemWhenExport else if value == String "traffic" then pure ServiceTelemetryTelemetrySpansItemWhenTraffic else if value == String "supervised" then pure ServiceTelemetryTelemetrySpansItemWhenSupervised else if value == String "fatal" then pure ServiceTelemetryTelemetrySpansItemWhenFatal else fail "unknown enumeration member"

instance ToJSON ServiceTelemetryTelemetrySpansItemWhen where
  toJSON ServiceTelemetryTelemetrySpansItemWhenExport = String "export"
  toJSON ServiceTelemetryTelemetrySpansItemWhenTraffic = String "traffic"
  toJSON ServiceTelemetryTelemetrySpansItemWhenSupervised = String "supervised"
  toJSON ServiceTelemetryTelemetrySpansItemWhenFatal = String "fatal"

serviceTelemetryTelemetrySpansItemWhenText :: ServiceTelemetryTelemetrySpansItemWhen -> Text
serviceTelemetryTelemetrySpansItemWhenText ServiceTelemetryTelemetrySpansItemWhenExport = "export"
serviceTelemetryTelemetrySpansItemWhenText ServiceTelemetryTelemetrySpansItemWhenTraffic = "traffic"
serviceTelemetryTelemetrySpansItemWhenText ServiceTelemetryTelemetrySpansItemWhenSupervised = "supervised"
serviceTelemetryTelemetrySpansItemWhenText ServiceTelemetryTelemetrySpansItemWhenFatal = "fatal"
