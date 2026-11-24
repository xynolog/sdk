-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StackKnowledgeBase (StackKnowledgeBase (..), StackKnowledgeBaseKind (..), stackKnowledgeBaseKindText, StackKnowledgeBaseSpec (..), StackKnowledgeBaseSpecArchivist (..), StackKnowledgeBaseSpecDispatcher (..), StackKnowledgeBaseSpecGateway (..), StackKnowledgeBaseSpecIssuer (..), StackKnowledgeBaseSpecIssuerExternal (..), StackKnowledgeBaseSpecIssuerShared (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HostPort
import Xynolog.Internal.Generated.Models.Image
import Xynolog.Internal.Generated.Models.LogLevel
import Xynolog.Internal.Generated.Models.Metadata
import Xynolog.Internal.Generated.Models.Resources
import Xynolog.Internal.Generated.Models.Runner
import Xynolog.Internal.Generated.Models.StackApiVersion

data StackKnowledgeBase = StackKnowledgeBase
  { stackKnowledgeBaseApiVersion :: StackApiVersion,
    stackKnowledgeBaseKind :: StackKnowledgeBaseKind,
    stackKnowledgeBaseMetadata :: Metadata,
    stackKnowledgeBaseSpec :: StackKnowledgeBaseSpec
  }
  deriving (Eq, Show)

instance FromJSON StackKnowledgeBase where parseJSON = checked "StackKnowledgeBase" $ withObject "StackKnowledgeBase" (\fields -> StackKnowledgeBase <$> (fields .: "apiVersion") <*> (fields .: "kind") <*> (fields .: "metadata") <*> (fields .: "spec"))

instance ToJSON StackKnowledgeBase where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (stackKnowledgeBaseApiVersion value))], [("kind", toJSON (stackKnowledgeBaseKind value))], [("metadata", toJSON (stackKnowledgeBaseMetadata value))], [("spec", toJSON (stackKnowledgeBaseSpec value))]]))

data StackKnowledgeBaseKind = StackKnowledgeBaseKindKnowledgeBase deriving (Eq, Show)

instance FromJSON StackKnowledgeBaseKind where parseJSON = checked "StackKnowledgeBaseKind" $ \value -> if value == String "KnowledgeBase" then pure StackKnowledgeBaseKindKnowledgeBase else fail "unknown enumeration member"

instance ToJSON StackKnowledgeBaseKind where toJSON StackKnowledgeBaseKindKnowledgeBase = String "KnowledgeBase"

stackKnowledgeBaseKindText :: StackKnowledgeBaseKind -> Text
stackKnowledgeBaseKindText StackKnowledgeBaseKindKnowledgeBase = "KnowledgeBase"

data StackKnowledgeBaseSpec = StackKnowledgeBaseSpec
  { stackKnowledgeBaseSpecArchivist :: StackKnowledgeBaseSpecArchivist,
    stackKnowledgeBaseSpecDispatcher :: StackKnowledgeBaseSpecDispatcher,
    stackKnowledgeBaseSpecGateway :: StackKnowledgeBaseSpecGateway,
    stackKnowledgeBaseSpecIssuer :: StackKnowledgeBaseSpecIssuer,
    stackKnowledgeBaseSpecLogLevel :: LogLevel,
    stackKnowledgeBaseSpecMessaging :: Runner
  }
  deriving (Eq, Show)

instance FromJSON StackKnowledgeBaseSpec where parseJSON = checked "StackKnowledgeBaseSpec" $ withObject "StackKnowledgeBaseSpec" (\fields -> StackKnowledgeBaseSpec <$> (fields .: "archivist") <*> (fields .: "dispatcher") <*> (fields .: "gateway") <*> (fields .: "issuer") <*> (fields .: "logLevel") <*> (fields .: "messaging"))

instance ToJSON StackKnowledgeBaseSpec where toJSON value = Object (KM.fromList (concat [[("archivist", toJSON (stackKnowledgeBaseSpecArchivist value))], [("dispatcher", toJSON (stackKnowledgeBaseSpecDispatcher value))], [("gateway", toJSON (stackKnowledgeBaseSpecGateway value))], [("issuer", toJSON (stackKnowledgeBaseSpecIssuer value))], [("logLevel", toJSON (stackKnowledgeBaseSpecLogLevel value))], [("messaging", toJSON (stackKnowledgeBaseSpecMessaging value))]]))

data StackKnowledgeBaseSpecArchivist = StackKnowledgeBaseSpecArchivist
  { stackKnowledgeBaseSpecArchivistAddress :: Maybe HostPort,
    stackKnowledgeBaseSpecArchivistImage :: Image,
    stackKnowledgeBaseSpecArchivistResources :: Resources
  }
  deriving (Eq, Show)

instance FromJSON StackKnowledgeBaseSpecArchivist where parseJSON = checked "StackKnowledgeBaseSpecArchivist" $ withObject "StackKnowledgeBaseSpecArchivist" (\fields -> StackKnowledgeBaseSpecArchivist <$> optional fields "address" <*> (fields .: "image") <*> (fields .: "resources"))

instance ToJSON StackKnowledgeBaseSpecArchivist where toJSON value = Object (KM.fromList (concat [optionalPair "address" (stackKnowledgeBaseSpecArchivistAddress value), [("image", toJSON (stackKnowledgeBaseSpecArchivistImage value))], [("resources", toJSON (stackKnowledgeBaseSpecArchivistResources value))]]))

data StackKnowledgeBaseSpecDispatcher = StackKnowledgeBaseSpecDispatcher
  { stackKnowledgeBaseSpecDispatcherImage :: Image,
    stackKnowledgeBaseSpecDispatcherResources :: Resources
  }
  deriving (Eq, Show)

instance FromJSON StackKnowledgeBaseSpecDispatcher where parseJSON = checked "StackKnowledgeBaseSpecDispatcher" $ withObject "StackKnowledgeBaseSpecDispatcher" (\fields -> StackKnowledgeBaseSpecDispatcher <$> (fields .: "image") <*> (fields .: "resources"))

instance ToJSON StackKnowledgeBaseSpecDispatcher where toJSON value = Object (KM.fromList (concat [[("image", toJSON (stackKnowledgeBaseSpecDispatcherImage value))], [("resources", toJSON (stackKnowledgeBaseSpecDispatcherResources value))]]))

data StackKnowledgeBaseSpecGateway = StackKnowledgeBaseSpecGateway
  { stackKnowledgeBaseSpecGatewayImage :: Image,
    stackKnowledgeBaseSpecGatewayPort :: Integer,
    stackKnowledgeBaseSpecGatewayPublicURL :: Text,
    stackKnowledgeBaseSpecGatewayResources :: Resources
  }
  deriving (Eq, Show)

instance FromJSON StackKnowledgeBaseSpecGateway where parseJSON = checked "StackKnowledgeBaseSpecGateway" $ withObject "StackKnowledgeBaseSpecGateway" (\fields -> StackKnowledgeBaseSpecGateway <$> (fields .: "image") <*> (fields .: "port") <*> (fields .: "publicURL") <*> (fields .: "resources"))

instance ToJSON StackKnowledgeBaseSpecGateway where toJSON value = Object (KM.fromList (concat [[("image", toJSON (stackKnowledgeBaseSpecGatewayImage value))], [("port", toJSON (stackKnowledgeBaseSpecGatewayPort value))], [("publicURL", toJSON (stackKnowledgeBaseSpecGatewayPublicURL value))], [("resources", toJSON (stackKnowledgeBaseSpecGatewayResources value))]]))

data StackKnowledgeBaseSpecIssuer = StackKnowledgeBaseSpecIssuer
  { stackKnowledgeBaseSpecIssuerExternal :: Maybe StackKnowledgeBaseSpecIssuerExternal,
    stackKnowledgeBaseSpecIssuerShared :: Maybe StackKnowledgeBaseSpecIssuerShared,
    stackKnowledgeBaseSpecIssuerSubjectClaim :: Text
  }
  deriving (Eq, Show)

instance FromJSON StackKnowledgeBaseSpecIssuer where parseJSON = checked "StackKnowledgeBaseSpecIssuer" $ withObject "StackKnowledgeBaseSpecIssuer" (\fields -> StackKnowledgeBaseSpecIssuer <$> optional fields "external" <*> optional fields "shared" <*> (fields .: "subjectClaim"))

instance ToJSON StackKnowledgeBaseSpecIssuer where toJSON value = Object (KM.fromList (concat [optionalPair "external" (stackKnowledgeBaseSpecIssuerExternal value), optionalPair "shared" (stackKnowledgeBaseSpecIssuerShared value), [("subjectClaim", toJSON (stackKnowledgeBaseSpecIssuerSubjectClaim value))]]))

data StackKnowledgeBaseSpecIssuerExternal = StackKnowledgeBaseSpecIssuerExternal
  { stackKnowledgeBaseSpecIssuerExternalType :: Text,
    stackKnowledgeBaseSpecIssuerExternalUrl :: Text
  }
  deriving (Eq, Show)

instance FromJSON StackKnowledgeBaseSpecIssuerExternal where parseJSON = checked "StackKnowledgeBaseSpecIssuerExternal" $ withObject "StackKnowledgeBaseSpecIssuerExternal" (\fields -> StackKnowledgeBaseSpecIssuerExternal <$> (fields .: "type") <*> (fields .: "url"))

instance ToJSON StackKnowledgeBaseSpecIssuerExternal where toJSON value = Object (KM.fromList (concat [[("type", toJSON (stackKnowledgeBaseSpecIssuerExternalType value))], [("url", toJSON (stackKnowledgeBaseSpecIssuerExternalUrl value))]]))

data StackKnowledgeBaseSpecIssuerShared = StackKnowledgeBaseSpecIssuerShared
  { stackKnowledgeBaseSpecIssuerSharedAccessTokenLifespan :: Integer
  }
  deriving (Eq, Show)

instance FromJSON StackKnowledgeBaseSpecIssuerShared where parseJSON = checked "StackKnowledgeBaseSpecIssuerShared" $ withObject "StackKnowledgeBaseSpecIssuerShared" (\fields -> StackKnowledgeBaseSpecIssuerShared <$> (fields .: "accessTokenLifespan"))

instance ToJSON StackKnowledgeBaseSpecIssuerShared where toJSON value = Object (KM.fromList (concat [[("accessTokenLifespan", toJSON (stackKnowledgeBaseSpecIssuerSharedAccessTokenLifespan value))]]))
