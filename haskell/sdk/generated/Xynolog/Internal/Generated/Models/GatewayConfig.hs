-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatewayConfig (GatewayConfig (..), GatewayConfigCapacity (..), GatewayConfigIdentity (..), GatewayConfigSignal (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceCase
import Xynolog.Internal.Generated.Models.KbIdentity
import Xynolog.Internal.Generated.Models.LogFormat
import Xynolog.Internal.Generated.Models.LogLevel
import Xynolog.Internal.Generated.Models.ServiceAddress

data GatewayConfig = GatewayConfig
  { gatewayConfigKb :: KbIdentity,
    gatewayConfigPort :: Integer,
    gatewayConfigPublicUrl :: Text,
    gatewayConfigIdentity :: GatewayConfigIdentity,
    gatewayConfigArchivist :: ServiceAddress,
    gatewayConfigSignal :: GatewayConfigSignal,
    gatewayConfigLogLevel :: LogLevel,
    gatewayConfigLogFormat :: LogFormat,
    gatewayConfigCapacity :: GatewayConfigCapacity
  }
  deriving (Eq, Show)

instance FromJSON GatewayConfig where parseJSON = checked "GatewayConfig" $ withObject "GatewayConfig" (\fields -> GatewayConfig <$> (fields .: "kb") <*> (fields .: "port") <*> (fields .: "publicUrl") <*> (fields .: "identity") <*> (fields .: "archivist") <*> (fields .: "signal") <*> (fields .: "logLevel") <*> (fields .: "logFormat") <*> (fields .: "capacity"))

instance ToJSON GatewayConfig where toJSON value = Object (KM.fromList (concat [[("kb", toJSON (gatewayConfigKb value))], [("port", toJSON (gatewayConfigPort value))], [("publicUrl", toJSON (gatewayConfigPublicUrl value))], [("identity", toJSON (gatewayConfigIdentity value))], [("archivist", toJSON (gatewayConfigArchivist value))], [("signal", toJSON (gatewayConfigSignal value))], [("logLevel", toJSON (gatewayConfigLogLevel value))], [("logFormat", toJSON (gatewayConfigLogFormat value))], [("capacity", toJSON (gatewayConfigCapacity value))]]))

data GatewayConfigCapacity = GatewayConfigCapacity
  { gatewayConfigCapacityQueuedBytes :: Integer,
    gatewayConfigCapacityConnections :: Integer
  }
  deriving (Eq, Show)

instance FromJSON GatewayConfigCapacity where parseJSON = checked "GatewayConfigCapacity" $ withObject "GatewayConfigCapacity" (\fields -> GatewayConfigCapacity <$> (fields .: "queuedBytes") <*> (fields .: "connections"))

instance ToJSON GatewayConfigCapacity where toJSON value = Object (KM.fromList (concat [[("queuedBytes", toJSON (gatewayConfigCapacityQueuedBytes value))], [("connections", toJSON (gatewayConfigCapacityConnections value))]]))

data GatewayConfigIdentity = GatewayConfigIdentity
  { gatewayConfigIdentityIssuer :: Text,
    gatewayConfigIdentitySubjectClaim :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayConfigIdentity where parseJSON = checked "GatewayConfigIdentity" $ withObject "GatewayConfigIdentity" (\fields -> GatewayConfigIdentity <$> (fields .: "issuer") <*> (fields .: "subjectClaim"))

instance ToJSON GatewayConfigIdentity where toJSON value = Object (KM.fromList (concat [[("issuer", toJSON (gatewayConfigIdentityIssuer value))], [("subjectClaim", toJSON (gatewayConfigIdentitySubjectClaim value))]]))

data GatewayConfigSignal = GatewayConfigSignal
  { gatewayConfigSignalType :: GatewayConfigSignalType,
    gatewayConfigSignalServers :: Maybe Text,
    gatewayConfigSignalUserEnv :: Maybe Text,
    gatewayConfigSignalPasswordEnv :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayConfigSignal where parseJSON = checked "GatewayConfigSignal" $ withObject "GatewayConfigSignal" (\fields -> GatewayConfigSignal <$> (fields .: "type") <*> optional fields "servers" <*> optional fields "userEnv" <*> optional fields "passwordEnv")

instance ToJSON GatewayConfigSignal where toJSON value = Object (KM.fromList (concat [[("type", toJSON (gatewayConfigSignalType value))], optionalPair "servers" (gatewayConfigSignalServers value), optionalPair "userEnv" (gatewayConfigSignalUserEnv value), optionalPair "passwordEnv" (gatewayConfigSignalPasswordEnv value)]))
