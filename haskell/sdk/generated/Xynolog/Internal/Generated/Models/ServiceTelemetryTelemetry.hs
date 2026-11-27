-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceTelemetryTelemetry (ServiceTelemetryTelemetry (..), ServiceTelemetryTelemetryMetricsItem (..), ServiceTelemetryTelemetryMetricsItemAttributesItem (..), ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem (..), ServiceTelemetryTelemetryResourceItem (..), ServiceTelemetryTelemetrySpansItem (..), ServiceTelemetryTelemetrySpansItemAttributesItem (..), ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem (..), ServiceTelemetryTelemetrySpansItemWhen (..), serviceTelemetryTelemetrySpansItemWhenText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceCase
import Xynolog.Internal.Generated.Models.SdkTelemetryTelemetry
import Xynolog.Internal.Generated.Models.ServiceEnvironmentBootRefusals

data ServiceTelemetryTelemetry = ServiceTelemetryTelemetry
  { serviceTelemetryTelemetryComment :: Text,
    serviceTelemetryTelemetrySdk :: KM.KeyMap [Text],
    serviceTelemetryTelemetryResource :: [ServiceTelemetryTelemetryResourceItem],
    serviceTelemetryTelemetrySpans :: [ServiceTelemetryTelemetrySpansItem],
    serviceTelemetryTelemetryMetrics :: [ServiceTelemetryTelemetryMetricsItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetry where parseJSON = checked "ServiceTelemetryTelemetry" $ withObject "ServiceTelemetryTelemetry" (\fields -> ServiceTelemetryTelemetry <$> (fields .: "$comment") <*> (fields .: "sdk") <*> (fields .: "resource") <*> (fields .: "spans") <*> (fields .: "metrics"))

instance ToJSON ServiceTelemetryTelemetry where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (serviceTelemetryTelemetryComment value))], [("sdk", toJSON (serviceTelemetryTelemetrySdk value))], [("resource", toJSON (serviceTelemetryTelemetryResource value))], [("spans", toJSON (serviceTelemetryTelemetrySpans value))], [("metrics", toJSON (serviceTelemetryTelemetryMetrics value))]]))

data ServiceTelemetryTelemetryMetricsItem = ServiceTelemetryTelemetryMetricsItem
  { serviceTelemetryTelemetryMetricsItemName :: Text,
    serviceTelemetryTelemetryMetricsItemServices :: [ServiceTelemetryTelemetrySpansItemServicesItem],
    serviceTelemetryTelemetryMetricsItemInstrument :: ServiceTelemetryTelemetryMetricsItemInstrument,
    serviceTelemetryTelemetryMetricsItemWhen :: ServiceTelemetryTelemetrySpansItemWhen,
    serviceTelemetryTelemetryMetricsItemPlanes :: Maybe [GatewayConfigSignalType],
    serviceTelemetryTelemetryMetricsItemMeaning :: Text,
    serviceTelemetryTelemetryMetricsItemAttributes :: [ServiceTelemetryTelemetryMetricsItemAttributesItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryMetricsItem where parseJSON = checked "ServiceTelemetryTelemetryMetricsItem" $ withObject "ServiceTelemetryTelemetryMetricsItem" (\fields -> ServiceTelemetryTelemetryMetricsItem <$> (fields .: "name") <*> (fields .: "services") <*> (fields .: "instrument") <*> (fields .: "when") <*> optional fields "planes" <*> (fields .: "meaning") <*> (fields .: "attributes"))

instance ToJSON ServiceTelemetryTelemetryMetricsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (serviceTelemetryTelemetryMetricsItemName value))], [("services", toJSON (serviceTelemetryTelemetryMetricsItemServices value))], [("instrument", toJSON (serviceTelemetryTelemetryMetricsItemInstrument value))], [("when", toJSON (serviceTelemetryTelemetryMetricsItemWhen value))], optionalPair "planes" (serviceTelemetryTelemetryMetricsItemPlanes value), [("meaning", toJSON (serviceTelemetryTelemetryMetricsItemMeaning value))], [("attributes", toJSON (serviceTelemetryTelemetryMetricsItemAttributes value))]]))

data ServiceTelemetryTelemetryMetricsItemAttributesItem = ServiceTelemetryTelemetryMetricsItemAttributesItem
  { serviceTelemetryTelemetryMetricsItemAttributesItemKey :: Text,
    serviceTelemetryTelemetryMetricsItemAttributesItemOnly :: Maybe Text,
    serviceTelemetryTelemetryMetricsItemAttributesItemValues :: Maybe [ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryMetricsItemAttributesItem where parseJSON = checked "ServiceTelemetryTelemetryMetricsItemAttributesItem" $ withObject "ServiceTelemetryTelemetryMetricsItemAttributesItem" (\fields -> ServiceTelemetryTelemetryMetricsItemAttributesItem <$> (fields .: "key") <*> optional fields "only" <*> optional fields "values")

instance ToJSON ServiceTelemetryTelemetryMetricsItemAttributesItem where toJSON value = Object (KM.fromList (concat [[("key", toJSON (serviceTelemetryTelemetryMetricsItemAttributesItemKey value))], optionalPair "only" (serviceTelemetryTelemetryMetricsItemAttributesItemOnly value), optionalPair "values" (serviceTelemetryTelemetryMetricsItemAttributesItemValues value)]))

data ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem = ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText Text | ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean Bool deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem where parseJSON = checked "ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem" $ \value -> readMember "ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem" [([Signature {signatureKind = TextKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText <$> parseJSON value), ([Signature {signatureKind = BooleanKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean <$> parseJSON value)] value

instance ToJSON ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem where
  toJSON (ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText value) = toJSON value
  toJSON (ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean value) = toJSON value

data ServiceTelemetryTelemetryResourceItem = ServiceTelemetryTelemetryResourceItem
  { serviceTelemetryTelemetryResourceItemKey :: Text,
    serviceTelemetryTelemetryResourceItemServices :: [ServiceTelemetryTelemetrySpansItemServicesItem],
    serviceTelemetryTelemetryResourceItemMeaning :: Text,
    serviceTelemetryTelemetryResourceItemDefault :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetryResourceItem where parseJSON = checked "ServiceTelemetryTelemetryResourceItem" $ withObject "ServiceTelemetryTelemetryResourceItem" (\fields -> ServiceTelemetryTelemetryResourceItem <$> (fields .: "key") <*> (fields .: "services") <*> (fields .: "meaning") <*> optional fields "default")

instance ToJSON ServiceTelemetryTelemetryResourceItem where toJSON value = Object (KM.fromList (concat [[("key", toJSON (serviceTelemetryTelemetryResourceItemKey value))], [("services", toJSON (serviceTelemetryTelemetryResourceItemServices value))], [("meaning", toJSON (serviceTelemetryTelemetryResourceItemMeaning value))], optionalPair "default" (serviceTelemetryTelemetryResourceItemDefault value)]))

data ServiceTelemetryTelemetrySpansItem = ServiceTelemetryTelemetrySpansItem
  { serviceTelemetryTelemetrySpansItemName :: Text,
    serviceTelemetryTelemetrySpansItemServices :: [ServiceTelemetryTelemetrySpansItemServicesItem],
    serviceTelemetryTelemetrySpansItemKind :: ServiceTelemetryTelemetrySpansItemKind,
    serviceTelemetryTelemetrySpansItemWhen :: ServiceTelemetryTelemetrySpansItemWhen,
    serviceTelemetryTelemetrySpansItemMeaning :: Text,
    serviceTelemetryTelemetrySpansItemAttributes :: [ServiceTelemetryTelemetrySpansItemAttributesItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetrySpansItem where parseJSON = checked "ServiceTelemetryTelemetrySpansItem" $ withObject "ServiceTelemetryTelemetrySpansItem" (\fields -> ServiceTelemetryTelemetrySpansItem <$> (fields .: "name") <*> (fields .: "services") <*> (fields .: "kind") <*> (fields .: "when") <*> (fields .: "meaning") <*> (fields .: "attributes"))

instance ToJSON ServiceTelemetryTelemetrySpansItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (serviceTelemetryTelemetrySpansItemName value))], [("services", toJSON (serviceTelemetryTelemetrySpansItemServices value))], [("kind", toJSON (serviceTelemetryTelemetrySpansItemKind value))], [("when", toJSON (serviceTelemetryTelemetrySpansItemWhen value))], [("meaning", toJSON (serviceTelemetryTelemetrySpansItemMeaning value))], [("attributes", toJSON (serviceTelemetryTelemetrySpansItemAttributes value))]]))

data ServiceTelemetryTelemetrySpansItemAttributesItem = ServiceTelemetryTelemetrySpansItemAttributesItem
  { serviceTelemetryTelemetrySpansItemAttributesItemKey :: Text,
    serviceTelemetryTelemetrySpansItemAttributesItemOnly :: Maybe Text,
    serviceTelemetryTelemetrySpansItemAttributesItemValues :: Maybe [ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetrySpansItemAttributesItem where parseJSON = checked "ServiceTelemetryTelemetrySpansItemAttributesItem" $ withObject "ServiceTelemetryTelemetrySpansItemAttributesItem" (\fields -> ServiceTelemetryTelemetrySpansItemAttributesItem <$> (fields .: "key") <*> optional fields "only" <*> optional fields "values")

instance ToJSON ServiceTelemetryTelemetrySpansItemAttributesItem where toJSON value = Object (KM.fromList (concat [[("key", toJSON (serviceTelemetryTelemetrySpansItemAttributesItemKey value))], optionalPair "only" (serviceTelemetryTelemetrySpansItemAttributesItemOnly value), optionalPair "values" (serviceTelemetryTelemetrySpansItemAttributesItemValues value)]))

data ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem = ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText Text | ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean Bool deriving (Eq, Show)

instance FromJSON ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem where parseJSON = checked "ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem" $ \value -> readMember "ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem" [([Signature {signatureKind = TextKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText <$> parseJSON value), ([Signature {signatureKind = BooleanKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean <$> parseJSON value)] value

instance ToJSON ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem where
  toJSON (ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText value) = toJSON value
  toJSON (ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean value) = toJSON value

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
