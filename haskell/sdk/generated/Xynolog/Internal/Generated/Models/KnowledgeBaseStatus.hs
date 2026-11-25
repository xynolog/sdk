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
  { knowledgeBaseStatusName :: Text,
    knowledgeBaseStatusKey :: Text,
    knowledgeBaseStatusRecorded :: Bool,
    knowledgeBaseStatusPlacement :: KnowledgeBaseStatusPlacement,
    knowledgeBaseStatusRoot :: Maybe Text,
    knowledgeBaseStatusRepo :: Maybe Text,
    knowledgeBaseStatusDid :: Maybe Text,
    knowledgeBaseStatusSiteName :: Maybe Text,
    knowledgeBaseStatusIdentityError :: Maybe Text,
    knowledgeBaseStatusKb :: Maybe DiscoveredKB,
    knowledgeBaseStatusRuntime :: Maybe Runtime,
    knowledgeBaseStatusGateway :: Maybe Text,
    knowledgeBaseStatusSecretStore :: Maybe Text,
    knowledgeBaseStatusLan :: Maybe Text,
    knowledgeBaseStatusStarting :: Bool,
    knowledgeBaseStatusSession :: Maybe Session,
    knowledgeBaseStatusHealthy :: Bool,
    knowledgeBaseStatusServices :: [ServiceStatus],
    knowledgeBaseStatusWorkload :: Maybe WorkloadStatus
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeBaseStatus where parseJSON = checked "KnowledgeBaseStatus" $ withObject "KnowledgeBaseStatus" (\fields -> KnowledgeBaseStatus <$> (fields .: "name") <*> (fields .: "key") <*> (fields .: "recorded") <*> (fields .: "placement") <*> optional fields "root" <*> optional fields "repo" <*> optional fields "did" <*> optional fields "siteName" <*> optional fields "identityError" <*> optional fields "kb" <*> optional fields "runtime" <*> optional fields "gateway" <*> optional fields "secretStore" <*> optional fields "lan" <*> (fields .: "starting") <*> optional fields "session" <*> (fields .: "healthy") <*> (fields .: "services") <*> optional fields "workload")

instance ToJSON KnowledgeBaseStatus where toJSON value = Object (KM.fromList (concat [[("name", toJSON (knowledgeBaseStatusName value))], [("key", toJSON (knowledgeBaseStatusKey value))], [("recorded", toJSON (knowledgeBaseStatusRecorded value))], [("placement", toJSON (knowledgeBaseStatusPlacement value))], optionalPair "root" (knowledgeBaseStatusRoot value), optionalPair "repo" (knowledgeBaseStatusRepo value), optionalPair "did" (knowledgeBaseStatusDid value), optionalPair "siteName" (knowledgeBaseStatusSiteName value), optionalPair "identityError" (knowledgeBaseStatusIdentityError value), optionalPair "kb" (knowledgeBaseStatusKb value), optionalPair "runtime" (knowledgeBaseStatusRuntime value), optionalPair "gateway" (knowledgeBaseStatusGateway value), optionalPair "secretStore" (knowledgeBaseStatusSecretStore value), optionalPair "lan" (knowledgeBaseStatusLan value), [("starting", toJSON (knowledgeBaseStatusStarting value))], optionalPair "session" (knowledgeBaseStatusSession value), [("healthy", toJSON (knowledgeBaseStatusHealthy value))], [("services", toJSON (knowledgeBaseStatusServices value))], optionalPair "workload" (knowledgeBaseStatusWorkload value)]))

data KnowledgeBaseStatusPlacement = KnowledgeBaseStatusPlacementLocal | KnowledgeBaseStatusPlacementCodespace deriving (Eq, Show)

instance FromJSON KnowledgeBaseStatusPlacement where parseJSON = checked "KnowledgeBaseStatusPlacement" $ \value -> if value == String "local" then pure KnowledgeBaseStatusPlacementLocal else if value == String "codespace" then pure KnowledgeBaseStatusPlacementCodespace else fail "unknown enumeration member"

instance ToJSON KnowledgeBaseStatusPlacement where
  toJSON KnowledgeBaseStatusPlacementLocal = String "local"
  toJSON KnowledgeBaseStatusPlacementCodespace = String "codespace"

knowledgeBaseStatusPlacementText :: KnowledgeBaseStatusPlacement -> Text
knowledgeBaseStatusPlacementText KnowledgeBaseStatusPlacementLocal = "local"
knowledgeBaseStatusPlacementText KnowledgeBaseStatusPlacementCodespace = "codespace"
