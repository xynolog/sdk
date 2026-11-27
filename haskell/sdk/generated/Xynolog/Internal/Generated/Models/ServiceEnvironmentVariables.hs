-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceEnvironmentVariables (ServiceEnvironmentVariables (..), ServiceEnvironmentVariablesVariablesItem (..), ServiceEnvironmentVariablesVariablesItemProvidedBy (..), serviceEnvironmentVariablesVariablesItemProvidedByText, ServiceEnvironmentVariablesVariablesItemReadBy (..), serviceEnvironmentVariablesVariablesItemReadByText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ServiceEnvironmentBootRefusals

data ServiceEnvironmentVariables = ServiceEnvironmentVariables
  { serviceEnvironmentVariablesComment :: Text,
    serviceEnvironmentVariablesVariables :: [ServiceEnvironmentVariablesVariablesItem]
  }
  deriving (Eq, Show)

instance FromJSON ServiceEnvironmentVariables where parseJSON = checked "ServiceEnvironmentVariables" $ withObject "ServiceEnvironmentVariables" (\fields -> ServiceEnvironmentVariables <$> (fields .: "$comment") <*> (fields .: "variables"))

instance ToJSON ServiceEnvironmentVariables where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (serviceEnvironmentVariablesComment value))], [("variables", toJSON (serviceEnvironmentVariablesVariables value))]]))

data ServiceEnvironmentVariablesVariablesItem = ServiceEnvironmentVariablesVariablesItem
  { serviceEnvironmentVariablesVariablesItemName :: Text,
    serviceEnvironmentVariablesVariablesItemServices :: [ServiceTelemetryTelemetrySpansItemServicesItem],
    serviceEnvironmentVariablesVariablesItemReadBy :: ServiceEnvironmentVariablesVariablesItemReadBy,
    serviceEnvironmentVariablesVariablesItemProvidedBy :: ServiceEnvironmentVariablesVariablesItemProvidedBy,
    serviceEnvironmentVariablesVariablesItemRequired :: Bool,
    serviceEnvironmentVariablesVariablesItemEffect :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceEnvironmentVariablesVariablesItem where parseJSON = checked "ServiceEnvironmentVariablesVariablesItem" $ withObject "ServiceEnvironmentVariablesVariablesItem" (\fields -> ServiceEnvironmentVariablesVariablesItem <$> (fields .: "name") <*> (fields .: "services") <*> (fields .: "readBy") <*> (fields .: "providedBy") <*> (fields .: "required") <*> (fields .: "effect"))

instance ToJSON ServiceEnvironmentVariablesVariablesItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (serviceEnvironmentVariablesVariablesItemName value))], [("services", toJSON (serviceEnvironmentVariablesVariablesItemServices value))], [("readBy", toJSON (serviceEnvironmentVariablesVariablesItemReadBy value))], [("providedBy", toJSON (serviceEnvironmentVariablesVariablesItemProvidedBy value))], [("required", toJSON (serviceEnvironmentVariablesVariablesItemRequired value))], [("effect", toJSON (serviceEnvironmentVariablesVariablesItemEffect value))]]))

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
