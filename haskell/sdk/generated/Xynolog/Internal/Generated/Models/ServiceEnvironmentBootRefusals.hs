-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceEnvironmentBootRefusals (ServiceEnvironmentBootRefusals (..), ServiceEnvironmentBootRefusalsMembersItem (..), ServiceEnvironmentBootRefusalsRefusalsItem (..), ServiceTelemetryTelemetrySpansItemServicesItem (..), serviceTelemetryTelemetrySpansItemServicesItemText) where

import Data.Aeson (FromJSON (..), FromJSONKey (..), FromJSONKeyFunction (..), ToJSON (..), ToJSONKey (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Aeson.Types (toJSONKeyText)
import Data.Text (Text)
import Xynolog.Internal.Codec

data ServiceEnvironmentBootRefusals = ServiceEnvironmentBootRefusals
  { serviceEnvironmentBootRefusalsComment :: Text,
    serviceEnvironmentBootRefusalsServices :: [ServiceTelemetryTelemetrySpansItemServicesItem],
    serviceEnvironmentBootRefusalsLine :: Text,
    serviceEnvironmentBootRefusalsExitCode :: Integer,
    serviceEnvironmentBootRefusalsRefusals :: [ServiceEnvironmentBootRefusalsRefusalsItem],
    serviceEnvironmentBootRefusalsMembers :: [ServiceEnvironmentBootRefusalsMembersItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceEnvironmentBootRefusals where parseJSON = checked "ServiceEnvironmentBootRefusals" $ withObject "ServiceEnvironmentBootRefusals" (\fields -> ServiceEnvironmentBootRefusals <$> (fields .: "$comment") <*> (fields .: "services") <*> (fields .: "line") <*> (fields .: "exitCode") <*> (fields .: "refusals") <*> (fields .: "members"))

instance ToJSON ServiceEnvironmentBootRefusals where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (serviceEnvironmentBootRefusalsComment value))], [("services", toJSON (serviceEnvironmentBootRefusalsServices value))], [("line", toJSON (serviceEnvironmentBootRefusalsLine value))], [("exitCode", toJSON (serviceEnvironmentBootRefusalsExitCode value))], [("refusals", toJSON (serviceEnvironmentBootRefusalsRefusals value))], [("members", toJSON (serviceEnvironmentBootRefusalsMembers value))]]))

data ServiceEnvironmentBootRefusalsMembersItem = ServiceEnvironmentBootRefusalsMembersItem
  { serviceEnvironmentBootRefusalsMembersItemName :: Text,
    serviceEnvironmentBootRefusalsMembersItemSituation :: Text,
    serviceEnvironmentBootRefusalsMembersItemLine :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceEnvironmentBootRefusalsMembersItem where parseJSON = checked "ServiceEnvironmentBootRefusalsMembersItem" $ withObject "ServiceEnvironmentBootRefusalsMembersItem" (\fields -> ServiceEnvironmentBootRefusalsMembersItem <$> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "line"))

instance ToJSON ServiceEnvironmentBootRefusalsMembersItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (serviceEnvironmentBootRefusalsMembersItemName value))], [("situation", toJSON (serviceEnvironmentBootRefusalsMembersItemSituation value))], [("line", toJSON (serviceEnvironmentBootRefusalsMembersItemLine value))]]))

data ServiceEnvironmentBootRefusalsRefusalsItem = ServiceEnvironmentBootRefusalsRefusalsItem
  { serviceEnvironmentBootRefusalsRefusalsItemName :: Text,
    serviceEnvironmentBootRefusalsRefusalsItemSituation :: Text,
    serviceEnvironmentBootRefusalsRefusalsItemRefusal :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceEnvironmentBootRefusalsRefusalsItem where parseJSON = checked "ServiceEnvironmentBootRefusalsRefusalsItem" $ withObject "ServiceEnvironmentBootRefusalsRefusalsItem" (\fields -> ServiceEnvironmentBootRefusalsRefusalsItem <$> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "refusal"))

instance ToJSON ServiceEnvironmentBootRefusalsRefusalsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (serviceEnvironmentBootRefusalsRefusalsItemName value))], [("situation", toJSON (serviceEnvironmentBootRefusalsRefusalsItemSituation value))], [("refusal", toJSON (serviceEnvironmentBootRefusalsRefusalsItemRefusal value))]]))

data ServiceTelemetryTelemetrySpansItemServicesItem = ServiceTelemetryTelemetrySpansItemServicesItemArchivist | ServiceTelemetryTelemetrySpansItemServicesItemDispatcher | ServiceTelemetryTelemetrySpansItemServicesItemGateway | ServiceTelemetryTelemetrySpansItemServicesItemLibrarian | ServiceTelemetryTelemetrySpansItemServicesItemSmelter | ServiceTelemetryTelemetrySpansItemServicesItemWeaver | ServiceTelemetryTelemetrySpansItemServicesItemWorker deriving (Eq, Ord, Show)

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

instance FromJSONKey ServiceTelemetryTelemetrySpansItemServicesItem where fromJSONKey = FromJSONKeyTextParser (parseJSON . String)

instance ToJSONKey ServiceTelemetryTelemetrySpansItemServicesItem where toJSONKey = toJSONKeyText serviceTelemetryTelemetrySpansItemServicesItemText
