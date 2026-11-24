-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceTelemetryLogLines (ServiceTelemetryLogLines (..), ServiceTelemetryLogLinesBus (..), ServiceTelemetryLogLinesBusPartsItem (..), ServiceTelemetryLogLinesLogger (..), ServiceTelemetryLogLinesLoggerJson (..), ServiceTelemetryLogLinesLoggerServicesItem (..), serviceTelemetryLogLinesLoggerServicesItemText, ServiceTelemetryLogLinesSupervisor (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ServiceTelemetryLogLines = ServiceTelemetryLogLines
  { serviceTelemetryLogLinesU24_comment :: Text,
    serviceTelemetryLogLinesBus :: ServiceTelemetryLogLinesBus,
    serviceTelemetryLogLinesLogger :: ServiceTelemetryLogLinesLogger,
    serviceTelemetryLogLinesSupervisor :: ServiceTelemetryLogLinesSupervisor
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLines where parseJSON = checked "ServiceTelemetryLogLines" $ withObject "ServiceTelemetryLogLines" (\fields -> ServiceTelemetryLogLines <$> (fields .: "$comment") <*> (fields .: "bus") <*> (fields .: "logger") <*> (fields .: "supervisor"))

instance ToJSON ServiceTelemetryLogLines where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (serviceTelemetryLogLinesU24_comment value))], [("bus", toJSON (serviceTelemetryLogLinesBus value))], [("logger", toJSON (serviceTelemetryLogLinesLogger value))], [("supervisor", toJSON (serviceTelemetryLogLinesSupervisor value))]]))

data ServiceTelemetryLogLinesBus = ServiceTelemetryLogLinesBus
  { serviceTelemetryLogLinesBusLine :: Text,
    serviceTelemetryLogLinesBusOps :: [Text],
    serviceTelemetryLogLinesBusParts :: [ServiceTelemetryLogLinesBusPartsItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesBus where parseJSON = checked "ServiceTelemetryLogLinesBus" $ withObject "ServiceTelemetryLogLinesBus" (\fields -> ServiceTelemetryLogLinesBus <$> (fields .: "line") <*> (fields .: "ops") <*> (fields .: "parts"))

instance ToJSON ServiceTelemetryLogLinesBus where toJSON value = Object (KM.fromList (concat [[("line", toJSON (serviceTelemetryLogLinesBusLine value))], [("ops", toJSON (serviceTelemetryLogLinesBusOps value))], [("parts", toJSON (serviceTelemetryLogLinesBusParts value))]]))

data ServiceTelemetryLogLinesBusPartsItem = ServiceTelemetryLogLinesBusPartsItem
  { serviceTelemetryLogLinesBusPartsItemCharacters :: Maybe Integer,
    serviceTelemetryLogLinesBusPartsItemPart :: Text,
    serviceTelemetryLogLinesBusPartsItemText :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesBusPartsItem where parseJSON = checked "ServiceTelemetryLogLinesBusPartsItem" $ withObject "ServiceTelemetryLogLinesBusPartsItem" (\fields -> ServiceTelemetryLogLinesBusPartsItem <$> optional fields "characters" <*> (fields .: "part") <*> (fields .: "text"))

instance ToJSON ServiceTelemetryLogLinesBusPartsItem where toJSON value = Object (KM.fromList (concat [optionalPair "characters" (serviceTelemetryLogLinesBusPartsItemCharacters value), [("part", toJSON (serviceTelemetryLogLinesBusPartsItemPart value))], [("text", toJSON (serviceTelemetryLogLinesBusPartsItemText value))]]))

data ServiceTelemetryLogLinesLogger = ServiceTelemetryLogLinesLogger
  { serviceTelemetryLogLinesLoggerJson :: ServiceTelemetryLogLinesLoggerJson,
    serviceTelemetryLogLinesLoggerServices :: [ServiceTelemetryLogLinesLoggerServicesItem],
    serviceTelemetryLogLinesLoggerSimple :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesLogger where parseJSON = checked "ServiceTelemetryLogLinesLogger" $ withObject "ServiceTelemetryLogLinesLogger" (\fields -> ServiceTelemetryLogLinesLogger <$> (fields .: "json") <*> (fields .: "services") <*> (fields .: "simple"))

instance ToJSON ServiceTelemetryLogLinesLogger where toJSON value = Object (KM.fromList (concat [[("json", toJSON (serviceTelemetryLogLinesLoggerJson value))], [("services", toJSON (serviceTelemetryLogLinesLoggerServices value))], [("simple", toJSON (serviceTelemetryLogLinesLoggerSimple value))]]))

data ServiceTelemetryLogLinesLoggerJson = ServiceTelemetryLogLinesLoggerJson
  { serviceTelemetryLogLinesLoggerJsonFirst :: [Text],
    serviceTelemetryLogLinesLoggerJsonLast :: Text,
    serviceTelemetryLogLinesLoggerJsonRequestId :: Text,
    serviceTelemetryLogLinesLoggerJsonTrace :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesLoggerJson where parseJSON = checked "ServiceTelemetryLogLinesLoggerJson" $ withObject "ServiceTelemetryLogLinesLoggerJson" (\fields -> ServiceTelemetryLogLinesLoggerJson <$> (fields .: "first") <*> (fields .: "last") <*> (fields .: "requestId") <*> (fields .: "trace"))

instance ToJSON ServiceTelemetryLogLinesLoggerJson where toJSON value = Object (KM.fromList (concat [[("first", toJSON (serviceTelemetryLogLinesLoggerJsonFirst value))], [("last", toJSON (serviceTelemetryLogLinesLoggerJsonLast value))], [("requestId", toJSON (serviceTelemetryLogLinesLoggerJsonRequestId value))], [("trace", toJSON (serviceTelemetryLogLinesLoggerJsonTrace value))]]))

data ServiceTelemetryLogLinesLoggerServicesItem = ServiceTelemetryLogLinesLoggerServicesItemArchivist | ServiceTelemetryLogLinesLoggerServicesItemDispatcher | ServiceTelemetryLogLinesLoggerServicesItemGateway deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesLoggerServicesItem where parseJSON = checked "ServiceTelemetryLogLinesLoggerServicesItem" $ \value -> if value == String "archivist" then pure ServiceTelemetryLogLinesLoggerServicesItemArchivist else if value == String "dispatcher" then pure ServiceTelemetryLogLinesLoggerServicesItemDispatcher else if value == String "gateway" then pure ServiceTelemetryLogLinesLoggerServicesItemGateway else fail "unknown enumeration member"

instance ToJSON ServiceTelemetryLogLinesLoggerServicesItem where
  toJSON ServiceTelemetryLogLinesLoggerServicesItemArchivist = String "archivist"
  toJSON ServiceTelemetryLogLinesLoggerServicesItemDispatcher = String "dispatcher"
  toJSON ServiceTelemetryLogLinesLoggerServicesItemGateway = String "gateway"

serviceTelemetryLogLinesLoggerServicesItemText :: ServiceTelemetryLogLinesLoggerServicesItem -> Text
serviceTelemetryLogLinesLoggerServicesItemText ServiceTelemetryLogLinesLoggerServicesItemArchivist = "archivist"
serviceTelemetryLogLinesLoggerServicesItemText ServiceTelemetryLogLinesLoggerServicesItemDispatcher = "dispatcher"
serviceTelemetryLogLinesLoggerServicesItemText ServiceTelemetryLogLinesLoggerServicesItemGateway = "gateway"

data ServiceTelemetryLogLinesSupervisor = ServiceTelemetryLogLinesSupervisor
  { serviceTelemetryLogLinesSupervisorCounted :: Text,
    serviceTelemetryLogLinesSupervisorLine :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesSupervisor where parseJSON = checked "ServiceTelemetryLogLinesSupervisor" $ withObject "ServiceTelemetryLogLinesSupervisor" (\fields -> ServiceTelemetryLogLinesSupervisor <$> (fields .: "counted") <*> (fields .: "line"))

instance ToJSON ServiceTelemetryLogLinesSupervisor where toJSON value = Object (KM.fromList (concat [[("counted", toJSON (serviceTelemetryLogLinesSupervisorCounted value))], [("line", toJSON (serviceTelemetryLogLinesSupervisorLine value))]]))
