-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceTelemetryLogLines (ServiceTelemetryLogLines (..), ServiceTelemetryLogLinesBus (..), ServiceTelemetryLogLinesBusPartsItem (..), ServiceTelemetryLogLinesLogger (..), ServiceTelemetryLogLinesLoggerJson (..), ServiceTelemetryLogLinesLoggerServicesItem (..), serviceTelemetryLogLinesLoggerServicesItemText, ServiceTelemetryLogLinesSupervisor (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ServiceTelemetryLogLines = ServiceTelemetryLogLines
  { serviceTelemetryLogLinesComment :: Text,
    serviceTelemetryLogLinesLogger :: ServiceTelemetryLogLinesLogger,
    serviceTelemetryLogLinesBus :: ServiceTelemetryLogLinesBus,
    serviceTelemetryLogLinesSupervisor :: ServiceTelemetryLogLinesSupervisor
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLines where parseJSON = checked "ServiceTelemetryLogLines" $ withObject "ServiceTelemetryLogLines" (\fields -> ServiceTelemetryLogLines <$> (fields .: "$comment") <*> (fields .: "logger") <*> (fields .: "bus") <*> (fields .: "supervisor"))

instance ToJSON ServiceTelemetryLogLines where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (serviceTelemetryLogLinesComment value))], [("logger", toJSON (serviceTelemetryLogLinesLogger value))], [("bus", toJSON (serviceTelemetryLogLinesBus value))], [("supervisor", toJSON (serviceTelemetryLogLinesSupervisor value))]]))

data ServiceTelemetryLogLinesBus = ServiceTelemetryLogLinesBus
  { serviceTelemetryLogLinesBusLine :: Text,
    serviceTelemetryLogLinesBusParts :: [ServiceTelemetryLogLinesBusPartsItem],
    serviceTelemetryLogLinesBusOps :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesBus where parseJSON = checked "ServiceTelemetryLogLinesBus" $ withObject "ServiceTelemetryLogLinesBus" (\fields -> ServiceTelemetryLogLinesBus <$> (fields .: "line") <*> (fields .: "parts") <*> (fields .: "ops"))

instance ToJSON ServiceTelemetryLogLinesBus where toJSON value = Object (KM.fromList (concat [[("line", toJSON (serviceTelemetryLogLinesBusLine value))], [("parts", toJSON (serviceTelemetryLogLinesBusParts value))], [("ops", toJSON (serviceTelemetryLogLinesBusOps value))]]))

data ServiceTelemetryLogLinesBusPartsItem = ServiceTelemetryLogLinesBusPartsItem
  { serviceTelemetryLogLinesBusPartsItemPart :: Text,
    serviceTelemetryLogLinesBusPartsItemText :: Text,
    serviceTelemetryLogLinesBusPartsItemCharacters :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesBusPartsItem where parseJSON = checked "ServiceTelemetryLogLinesBusPartsItem" $ withObject "ServiceTelemetryLogLinesBusPartsItem" (\fields -> ServiceTelemetryLogLinesBusPartsItem <$> (fields .: "part") <*> (fields .: "text") <*> optional fields "characters")

instance ToJSON ServiceTelemetryLogLinesBusPartsItem where toJSON value = Object (KM.fromList (concat [[("part", toJSON (serviceTelemetryLogLinesBusPartsItemPart value))], [("text", toJSON (serviceTelemetryLogLinesBusPartsItemText value))], optionalPair "characters" (serviceTelemetryLogLinesBusPartsItemCharacters value)]))

data ServiceTelemetryLogLinesLogger = ServiceTelemetryLogLinesLogger
  { serviceTelemetryLogLinesLoggerServices :: [ServiceTelemetryLogLinesLoggerServicesItem],
    serviceTelemetryLogLinesLoggerJson :: ServiceTelemetryLogLinesLoggerJson,
    serviceTelemetryLogLinesLoggerSimple :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesLogger where parseJSON = checked "ServiceTelemetryLogLinesLogger" $ withObject "ServiceTelemetryLogLinesLogger" (\fields -> ServiceTelemetryLogLinesLogger <$> (fields .: "services") <*> (fields .: "json") <*> (fields .: "simple"))

instance ToJSON ServiceTelemetryLogLinesLogger where toJSON value = Object (KM.fromList (concat [[("services", toJSON (serviceTelemetryLogLinesLoggerServices value))], [("json", toJSON (serviceTelemetryLogLinesLoggerJson value))], [("simple", toJSON (serviceTelemetryLogLinesLoggerSimple value))]]))

data ServiceTelemetryLogLinesLoggerJson = ServiceTelemetryLogLinesLoggerJson
  { serviceTelemetryLogLinesLoggerJsonFirst :: [Text],
    serviceTelemetryLogLinesLoggerJsonRequestId :: Text,
    serviceTelemetryLogLinesLoggerJsonTrace :: [Text],
    serviceTelemetryLogLinesLoggerJsonLast :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesLoggerJson where parseJSON = checked "ServiceTelemetryLogLinesLoggerJson" $ withObject "ServiceTelemetryLogLinesLoggerJson" (\fields -> ServiceTelemetryLogLinesLoggerJson <$> (fields .: "first") <*> (fields .: "requestId") <*> (fields .: "trace") <*> (fields .: "last"))

instance ToJSON ServiceTelemetryLogLinesLoggerJson where toJSON value = Object (KM.fromList (concat [[("first", toJSON (serviceTelemetryLogLinesLoggerJsonFirst value))], [("requestId", toJSON (serviceTelemetryLogLinesLoggerJsonRequestId value))], [("trace", toJSON (serviceTelemetryLogLinesLoggerJsonTrace value))], [("last", toJSON (serviceTelemetryLogLinesLoggerJsonLast value))]]))

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
  { serviceTelemetryLogLinesSupervisorLine :: Text,
    serviceTelemetryLogLinesSupervisorCounted :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceTelemetryLogLinesSupervisor where parseJSON = checked "ServiceTelemetryLogLinesSupervisor" $ withObject "ServiceTelemetryLogLinesSupervisor" (\fields -> ServiceTelemetryLogLinesSupervisor <$> (fields .: "line") <*> (fields .: "counted"))

instance ToJSON ServiceTelemetryLogLinesSupervisor where toJSON value = Object (KM.fromList (concat [[("line", toJSON (serviceTelemetryLogLinesSupervisorLine value))], [("counted", toJSON (serviceTelemetryLogLinesSupervisorCounted value))]]))
