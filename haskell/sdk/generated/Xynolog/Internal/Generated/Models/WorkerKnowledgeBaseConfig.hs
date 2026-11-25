-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerKnowledgeBaseConfig (WorkerKnowledgeBaseConfig (..), WorkerKnowledgeBaseConfigIdentity (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.WorkerEngineConfig

data WorkerKnowledgeBaseConfig = WorkerKnowledgeBaseConfig
  { workerKnowledgeBaseConfigDomain :: Text,
    workerKnowledgeBaseConfigGatewayUrl :: Text,
    workerKnowledgeBaseConfigIdentity :: WorkerKnowledgeBaseConfigIdentity,
    workerKnowledgeBaseConfigEngines :: [WorkerEngineConfig]
  }
  deriving (Eq, Show)

instance FromJSON WorkerKnowledgeBaseConfig where parseJSON = checked "WorkerKnowledgeBaseConfig" $ withObject "WorkerKnowledgeBaseConfig" (\fields -> WorkerKnowledgeBaseConfig <$> (fields .: "domain") <*> (fields .: "gatewayUrl") <*> (fields .: "identity") <*> (fields .: "engines"))

instance ToJSON WorkerKnowledgeBaseConfig where toJSON value = Object (KM.fromList (concat [[("domain", toJSON (workerKnowledgeBaseConfigDomain value))], [("gatewayUrl", toJSON (workerKnowledgeBaseConfigGatewayUrl value))], [("identity", toJSON (workerKnowledgeBaseConfigIdentity value))], [("engines", toJSON (workerKnowledgeBaseConfigEngines value))]]))

data WorkerKnowledgeBaseConfigIdentity = WorkerKnowledgeBaseConfigIdentity
  { workerKnowledgeBaseConfigIdentityIssuer :: Text,
    workerKnowledgeBaseConfigIdentityClientId :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerKnowledgeBaseConfigIdentity where parseJSON = checked "WorkerKnowledgeBaseConfigIdentity" $ withObject "WorkerKnowledgeBaseConfigIdentity" (\fields -> WorkerKnowledgeBaseConfigIdentity <$> (fields .: "issuer") <*> (fields .: "clientId"))

instance ToJSON WorkerKnowledgeBaseConfigIdentity where toJSON value = Object (KM.fromList (concat [[("issuer", toJSON (workerKnowledgeBaseConfigIdentityIssuer value))], [("clientId", toJSON (workerKnowledgeBaseConfigIdentityClientId value))]]))
