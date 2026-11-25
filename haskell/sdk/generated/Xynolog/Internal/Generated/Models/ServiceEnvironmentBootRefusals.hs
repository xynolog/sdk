-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceEnvironmentBootRefusals (ServiceEnvironmentBootRefusals (..), ServiceEnvironmentBootRefusalsMembersItem (..), ServiceEnvironmentBootRefusalsRefusalsItem (..), ServiceEnvironmentBootRefusalsServicesItem (..), serviceEnvironmentBootRefusalsServicesItemText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ServiceEnvironmentBootRefusals = ServiceEnvironmentBootRefusals
  { serviceEnvironmentBootRefusalsComment :: Text,
    serviceEnvironmentBootRefusalsServices :: [ServiceEnvironmentBootRefusalsServicesItem],
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

data ServiceEnvironmentBootRefusalsServicesItem = ServiceEnvironmentBootRefusalsServicesItemArchivist | ServiceEnvironmentBootRefusalsServicesItemDispatcher | ServiceEnvironmentBootRefusalsServicesItemGateway | ServiceEnvironmentBootRefusalsServicesItemLibrarian | ServiceEnvironmentBootRefusalsServicesItemSmelter | ServiceEnvironmentBootRefusalsServicesItemWeaver | ServiceEnvironmentBootRefusalsServicesItemWorker deriving (Eq, Show)

instance FromJSON ServiceEnvironmentBootRefusalsServicesItem where parseJSON = checked "ServiceEnvironmentBootRefusalsServicesItem" $ \value -> if value == String "archivist" then pure ServiceEnvironmentBootRefusalsServicesItemArchivist else if value == String "dispatcher" then pure ServiceEnvironmentBootRefusalsServicesItemDispatcher else if value == String "gateway" then pure ServiceEnvironmentBootRefusalsServicesItemGateway else if value == String "librarian" then pure ServiceEnvironmentBootRefusalsServicesItemLibrarian else if value == String "smelter" then pure ServiceEnvironmentBootRefusalsServicesItemSmelter else if value == String "weaver" then pure ServiceEnvironmentBootRefusalsServicesItemWeaver else if value == String "worker" then pure ServiceEnvironmentBootRefusalsServicesItemWorker else fail "unknown enumeration member"

instance ToJSON ServiceEnvironmentBootRefusalsServicesItem where
  toJSON ServiceEnvironmentBootRefusalsServicesItemArchivist = String "archivist"
  toJSON ServiceEnvironmentBootRefusalsServicesItemDispatcher = String "dispatcher"
  toJSON ServiceEnvironmentBootRefusalsServicesItemGateway = String "gateway"
  toJSON ServiceEnvironmentBootRefusalsServicesItemLibrarian = String "librarian"
  toJSON ServiceEnvironmentBootRefusalsServicesItemSmelter = String "smelter"
  toJSON ServiceEnvironmentBootRefusalsServicesItemWeaver = String "weaver"
  toJSON ServiceEnvironmentBootRefusalsServicesItemWorker = String "worker"

serviceEnvironmentBootRefusalsServicesItemText :: ServiceEnvironmentBootRefusalsServicesItem -> Text
serviceEnvironmentBootRefusalsServicesItemText ServiceEnvironmentBootRefusalsServicesItemArchivist = "archivist"
serviceEnvironmentBootRefusalsServicesItemText ServiceEnvironmentBootRefusalsServicesItemDispatcher = "dispatcher"
serviceEnvironmentBootRefusalsServicesItemText ServiceEnvironmentBootRefusalsServicesItemGateway = "gateway"
serviceEnvironmentBootRefusalsServicesItemText ServiceEnvironmentBootRefusalsServicesItemLibrarian = "librarian"
serviceEnvironmentBootRefusalsServicesItemText ServiceEnvironmentBootRefusalsServicesItemSmelter = "smelter"
serviceEnvironmentBootRefusalsServicesItemText ServiceEnvironmentBootRefusalsServicesItemWeaver = "weaver"
serviceEnvironmentBootRefusalsServicesItemText ServiceEnvironmentBootRefusalsServicesItemWorker = "worker"
