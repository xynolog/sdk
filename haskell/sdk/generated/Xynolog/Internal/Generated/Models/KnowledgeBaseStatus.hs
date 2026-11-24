-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KnowledgeBaseStatus (KnowledgeBaseStatus (..), KnowledgeBaseStatusPlacement (..), knowledgeBaseStatusPlacementText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveredKB
import Xynolog.Internal.Generated.Models.Runtime
import Xynolog.Internal.Generated.Models.ServiceStatus
import Xynolog.Internal.Generated.Models.Session
import Xynolog.Internal.Generated.Models.WorkloadStatus

data KnowledgeBaseStatus = KnowledgeBaseStatus
  { knowledgeBaseStatusDid :: Maybe Text,
    knowledgeBaseStatusGateway :: Maybe Text,
    knowledgeBaseStatusHealthy :: Bool,
    knowledgeBaseStatusIdentityError :: Maybe Text,
    knowledgeBaseStatusKb :: Maybe DiscoveredKB,
    knowledgeBaseStatusKey :: Text,
    knowledgeBaseStatusLan :: Maybe Text,
    knowledgeBaseStatusName :: Text,
    knowledgeBaseStatusPlacement :: KnowledgeBaseStatusPlacement,
    knowledgeBaseStatusRecorded :: Bool,
    knowledgeBaseStatusRepo :: Maybe Text,
    knowledgeBaseStatusRoot :: Maybe Text,
    knowledgeBaseStatusRuntime :: Maybe Runtime,
    knowledgeBaseStatusSecretStore :: Maybe Text,
    knowledgeBaseStatusServices :: [ServiceStatus],
    knowledgeBaseStatusSession :: Maybe Session,
    knowledgeBaseStatusSiteName :: Maybe Text,
    knowledgeBaseStatusStarting :: Bool,
    knowledgeBaseStatusWorkload :: Maybe WorkloadStatus
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeBaseStatus where parseJSON = checked "KnowledgeBaseStatus" $ withObject "KnowledgeBaseStatus" (\fields -> KnowledgeBaseStatus <$> optional fields "did" <*> optional fields "gateway" <*> (fields .: "healthy") <*> optional fields "identityError" <*> optional fields "kb" <*> (fields .: "key") <*> optional fields "lan" <*> (fields .: "name") <*> (fields .: "placement") <*> (fields .: "recorded") <*> optional fields "repo" <*> optional fields "root" <*> optional fields "runtime" <*> optional fields "secretStore" <*> (fields .: "services") <*> optional fields "session" <*> optional fields "siteName" <*> (fields .: "starting") <*> optional fields "workload")

instance ToJSON KnowledgeBaseStatus where toJSON value = Object (KM.fromList (concat [optionalPair "did" (knowledgeBaseStatusDid value), optionalPair "gateway" (knowledgeBaseStatusGateway value), [("healthy", toJSON (knowledgeBaseStatusHealthy value))], optionalPair "identityError" (knowledgeBaseStatusIdentityError value), optionalPair "kb" (knowledgeBaseStatusKb value), [("key", toJSON (knowledgeBaseStatusKey value))], optionalPair "lan" (knowledgeBaseStatusLan value), [("name", toJSON (knowledgeBaseStatusName value))], [("placement", toJSON (knowledgeBaseStatusPlacement value))], [("recorded", toJSON (knowledgeBaseStatusRecorded value))], optionalPair "repo" (knowledgeBaseStatusRepo value), optionalPair "root" (knowledgeBaseStatusRoot value), optionalPair "runtime" (knowledgeBaseStatusRuntime value), optionalPair "secretStore" (knowledgeBaseStatusSecretStore value), [("services", toJSON (knowledgeBaseStatusServices value))], optionalPair "session" (knowledgeBaseStatusSession value), optionalPair "siteName" (knowledgeBaseStatusSiteName value), [("starting", toJSON (knowledgeBaseStatusStarting value))], optionalPair "workload" (knowledgeBaseStatusWorkload value)]))

data KnowledgeBaseStatusPlacement = KnowledgeBaseStatusPlacementLocal | KnowledgeBaseStatusPlacementCodespace deriving (Eq, Show)

instance FromJSON KnowledgeBaseStatusPlacement where parseJSON = checked "KnowledgeBaseStatusPlacement" $ \value -> if value == String "local" then pure KnowledgeBaseStatusPlacementLocal else if value == String "codespace" then pure KnowledgeBaseStatusPlacementCodespace else fail "unknown enumeration member"

instance ToJSON KnowledgeBaseStatusPlacement where
  toJSON KnowledgeBaseStatusPlacementLocal = String "local"
  toJSON KnowledgeBaseStatusPlacementCodespace = String "codespace"

knowledgeBaseStatusPlacementText :: KnowledgeBaseStatusPlacement -> Text
knowledgeBaseStatusPlacementText KnowledgeBaseStatusPlacementLocal = "local"
knowledgeBaseStatusPlacementText KnowledgeBaseStatusPlacementCodespace = "codespace"
