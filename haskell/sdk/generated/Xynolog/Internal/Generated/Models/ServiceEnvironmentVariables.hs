-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceEnvironmentVariables (ServiceEnvironmentVariables (..), ServiceEnvironmentVariablesVariablesItem (..), ServiceEnvironmentVariablesVariablesItemProvidedBy (..), serviceEnvironmentVariablesVariablesItemProvidedByText, ServiceEnvironmentVariablesVariablesItemReadBy (..), serviceEnvironmentVariablesVariablesItemReadByText, ServiceEnvironmentVariablesVariablesItemServicesItem (..), serviceEnvironmentVariablesVariablesItemServicesItemText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ServiceEnvironmentVariables = ServiceEnvironmentVariables
  { serviceEnvironmentVariablesVariables :: [ServiceEnvironmentVariablesVariablesItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceEnvironmentVariables where parseJSON = checked "ServiceEnvironmentVariables" $ withObject "ServiceEnvironmentVariables" (\fields -> ServiceEnvironmentVariables <$> (fields .: "variables"))

instance ToJSON ServiceEnvironmentVariables where toJSON value = Object (KM.fromList (concat [[("variables", toJSON (serviceEnvironmentVariablesVariables value))]]))

data ServiceEnvironmentVariablesVariablesItem = ServiceEnvironmentVariablesVariablesItem
  { serviceEnvironmentVariablesVariablesItemEffect :: Text,
    serviceEnvironmentVariablesVariablesItemName :: Text,
    serviceEnvironmentVariablesVariablesItemProvidedBy :: ServiceEnvironmentVariablesVariablesItemProvidedBy,
    serviceEnvironmentVariablesVariablesItemReadBy :: ServiceEnvironmentVariablesVariablesItemReadBy,
    serviceEnvironmentVariablesVariablesItemRequired :: Bool,
    serviceEnvironmentVariablesVariablesItemServices :: [ServiceEnvironmentVariablesVariablesItemServicesItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceEnvironmentVariablesVariablesItem where parseJSON = checked "ServiceEnvironmentVariablesVariablesItem" $ withObject "ServiceEnvironmentVariablesVariablesItem" (\fields -> ServiceEnvironmentVariablesVariablesItem <$> (fields .: "effect") <*> (fields .: "name") <*> (fields .: "providedBy") <*> (fields .: "readBy") <*> (fields .: "required") <*> (fields .: "services"))

instance ToJSON ServiceEnvironmentVariablesVariablesItem where toJSON value = Object (KM.fromList (concat [[("effect", toJSON (serviceEnvironmentVariablesVariablesItemEffect value))], [("name", toJSON (serviceEnvironmentVariablesVariablesItemName value))], [("providedBy", toJSON (serviceEnvironmentVariablesVariablesItemProvidedBy value))], [("readBy", toJSON (serviceEnvironmentVariablesVariablesItemReadBy value))], [("required", toJSON (serviceEnvironmentVariablesVariablesItemRequired value))], [("services", toJSON (serviceEnvironmentVariablesVariablesItemServices value))]]))

data ServiceEnvironmentVariablesVariablesItemProvidedBy = ServiceEnvironmentVariablesVariablesItemProvidedByLauncher | ServiceEnvironmentVariablesVariablesItemProvidedByImage | ServiceEnvironmentVariablesVariablesItemProvidedByOperator deriving (Eq, Show)

instance FromJSON ServiceEnvironmentVariablesVariablesItemProvidedBy where parseJSON = checked "ServiceEnvironmentVariablesVariablesItemProvidedBy" $ \value -> if value == String "launcher" then pure ServiceEnvironmentVariablesVariablesItemProvidedByLauncher else if value == String "image" then pure ServiceEnvironmentVariablesVariablesItemProvidedByImage else if value == String "operator" then pure ServiceEnvironmentVariablesVariablesItemProvidedByOperator else fail "unknown enumeration member"

instance ToJSON ServiceEnvironmentVariablesVariablesItemProvidedBy where
  toJSON ServiceEnvironmentVariablesVariablesItemProvidedByLauncher = String "launcher"
  toJSON ServiceEnvironmentVariablesVariablesItemProvidedByImage = String "image"
  toJSON ServiceEnvironmentVariablesVariablesItemProvidedByOperator = String "operator"

serviceEnvironmentVariablesVariablesItemProvidedByText :: ServiceEnvironmentVariablesVariablesItemProvidedBy -> Text
serviceEnvironmentVariablesVariablesItemProvidedByText ServiceEnvironmentVariablesVariablesItemProvidedByLauncher = "launcher"
serviceEnvironmentVariablesVariablesItemProvidedByText ServiceEnvironmentVariablesVariablesItemProvidedByImage = "image"
serviceEnvironmentVariablesVariablesItemProvidedByText ServiceEnvironmentVariablesVariablesItemProvidedByOperator = "operator"

data ServiceEnvironmentVariablesVariablesItemReadBy = ServiceEnvironmentVariablesVariablesItemReadByService | ServiceEnvironmentVariablesVariablesItemReadByOpentelemetry deriving (Eq, Show)

instance FromJSON ServiceEnvironmentVariablesVariablesItemReadBy where parseJSON = checked "ServiceEnvironmentVariablesVariablesItemReadBy" $ \value -> if value == String "service" then pure ServiceEnvironmentVariablesVariablesItemReadByService else if value == String "opentelemetry" then pure ServiceEnvironmentVariablesVariablesItemReadByOpentelemetry else fail "unknown enumeration member"

instance ToJSON ServiceEnvironmentVariablesVariablesItemReadBy where
  toJSON ServiceEnvironmentVariablesVariablesItemReadByService = String "service"
  toJSON ServiceEnvironmentVariablesVariablesItemReadByOpentelemetry = String "opentelemetry"

serviceEnvironmentVariablesVariablesItemReadByText :: ServiceEnvironmentVariablesVariablesItemReadBy -> Text
serviceEnvironmentVariablesVariablesItemReadByText ServiceEnvironmentVariablesVariablesItemReadByService = "service"
serviceEnvironmentVariablesVariablesItemReadByText ServiceEnvironmentVariablesVariablesItemReadByOpentelemetry = "opentelemetry"

data ServiceEnvironmentVariablesVariablesItemServicesItem = ServiceEnvironmentVariablesVariablesItemServicesItemArchivist | ServiceEnvironmentVariablesVariablesItemServicesItemDispatcher | ServiceEnvironmentVariablesVariablesItemServicesItemGateway | ServiceEnvironmentVariablesVariablesItemServicesItemLibrarian | ServiceEnvironmentVariablesVariablesItemServicesItemSmelter | ServiceEnvironmentVariablesVariablesItemServicesItemWeaver | ServiceEnvironmentVariablesVariablesItemServicesItemWorker deriving (Eq, Show)

instance FromJSON ServiceEnvironmentVariablesVariablesItemServicesItem where parseJSON = checked "ServiceEnvironmentVariablesVariablesItemServicesItem" $ \value -> if value == String "archivist" then pure ServiceEnvironmentVariablesVariablesItemServicesItemArchivist else if value == String "dispatcher" then pure ServiceEnvironmentVariablesVariablesItemServicesItemDispatcher else if value == String "gateway" then pure ServiceEnvironmentVariablesVariablesItemServicesItemGateway else if value == String "librarian" then pure ServiceEnvironmentVariablesVariablesItemServicesItemLibrarian else if value == String "smelter" then pure ServiceEnvironmentVariablesVariablesItemServicesItemSmelter else if value == String "weaver" then pure ServiceEnvironmentVariablesVariablesItemServicesItemWeaver else if value == String "worker" then pure ServiceEnvironmentVariablesVariablesItemServicesItemWorker else fail "unknown enumeration member"

instance ToJSON ServiceEnvironmentVariablesVariablesItemServicesItem where
  toJSON ServiceEnvironmentVariablesVariablesItemServicesItemArchivist = String "archivist"
  toJSON ServiceEnvironmentVariablesVariablesItemServicesItemDispatcher = String "dispatcher"
  toJSON ServiceEnvironmentVariablesVariablesItemServicesItemGateway = String "gateway"
  toJSON ServiceEnvironmentVariablesVariablesItemServicesItemLibrarian = String "librarian"
  toJSON ServiceEnvironmentVariablesVariablesItemServicesItemSmelter = String "smelter"
  toJSON ServiceEnvironmentVariablesVariablesItemServicesItemWeaver = String "weaver"
  toJSON ServiceEnvironmentVariablesVariablesItemServicesItemWorker = String "worker"

serviceEnvironmentVariablesVariablesItemServicesItemText :: ServiceEnvironmentVariablesVariablesItemServicesItem -> Text
serviceEnvironmentVariablesVariablesItemServicesItemText ServiceEnvironmentVariablesVariablesItemServicesItemArchivist = "archivist"
serviceEnvironmentVariablesVariablesItemServicesItemText ServiceEnvironmentVariablesVariablesItemServicesItemDispatcher = "dispatcher"
serviceEnvironmentVariablesVariablesItemServicesItemText ServiceEnvironmentVariablesVariablesItemServicesItemGateway = "gateway"
serviceEnvironmentVariablesVariablesItemServicesItemText ServiceEnvironmentVariablesVariablesItemServicesItemLibrarian = "librarian"
serviceEnvironmentVariablesVariablesItemServicesItemText ServiceEnvironmentVariablesVariablesItemServicesItemSmelter = "smelter"
serviceEnvironmentVariablesVariablesItemServicesItemText ServiceEnvironmentVariablesVariablesItemServicesItemWeaver = "weaver"
serviceEnvironmentVariablesVariablesItemServicesItemText ServiceEnvironmentVariablesVariablesItemServicesItemWorker = "worker"
