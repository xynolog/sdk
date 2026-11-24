-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Issuer (Issuer (..), IssuerKind (..), issuerKindText, IssuerSpec (..), IssuerSpecDatabase (..), IssuerSpecDatabaseExternal (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Image
import Xynolog.Internal.Generated.Models.Metadata
import Xynolog.Internal.Generated.Models.Resources
import Xynolog.Internal.Generated.Models.SecretRef
import Xynolog.Internal.Generated.Models.StackApiVersion

data Issuer = Issuer
  { issuerApiVersion :: StackApiVersion,
    issuerKind :: IssuerKind,
    issuerMetadata :: Metadata,
    issuerSpec :: IssuerSpec
  }
  deriving (Eq, Show)

instance FromJSON Issuer where parseJSON = checked "Issuer" $ withObject "Issuer" (\fields -> Issuer <$> (fields .: "apiVersion") <*> (fields .: "kind") <*> (fields .: "metadata") <*> (fields .: "spec"))

instance ToJSON Issuer where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (issuerApiVersion value))], [("kind", toJSON (issuerKind value))], [("metadata", toJSON (issuerMetadata value))], [("spec", toJSON (issuerSpec value))]]))

data IssuerKind = IssuerKindIssuer deriving (Eq, Show)

instance FromJSON IssuerKind where parseJSON = checked "IssuerKind" $ \value -> if value == String "Issuer" then pure IssuerKindIssuer else fail "unknown enumeration member"

instance ToJSON IssuerKind where toJSON IssuerKindIssuer = String "Issuer"

issuerKindText :: IssuerKind -> Text
issuerKindText IssuerKindIssuer = "Issuer"

data IssuerSpec = IssuerSpec
  { issuerSpecDatabase :: IssuerSpecDatabase,
    issuerSpecImage :: Image,
    issuerSpecPort :: Integer,
    issuerSpecResources :: Resources,
    issuerSpecType :: Text
  }
  deriving (Eq, Show)

instance FromJSON IssuerSpec where parseJSON = checked "IssuerSpec" $ withObject "IssuerSpec" (\fields -> IssuerSpec <$> (fields .: "database") <*> (fields .: "image") <*> (fields .: "port") <*> (fields .: "resources") <*> (fields .: "type"))

instance ToJSON IssuerSpec where toJSON value = Object (KM.fromList (concat [[("database", toJSON (issuerSpecDatabase value))], [("image", toJSON (issuerSpecImage value))], [("port", toJSON (issuerSpecPort value))], [("resources", toJSON (issuerSpecResources value))], [("type", toJSON (issuerSpecType value))]]))

data IssuerSpecDatabase = IssuerSpecDatabase
  { issuerSpecDatabaseExternal :: Maybe IssuerSpecDatabaseExternal,
    issuerSpecDatabaseImage :: Maybe Image,
    issuerSpecDatabaseName :: Text,
    issuerSpecDatabasePort :: Maybe Integer,
    issuerSpecDatabaseResources :: Maybe Resources,
    issuerSpecDatabaseType :: Text,
    issuerSpecDatabaseUser :: Text
  }
  deriving (Eq, Show)

instance FromJSON IssuerSpecDatabase where parseJSON = checked "IssuerSpecDatabase" $ withObject "IssuerSpecDatabase" (\fields -> IssuerSpecDatabase <$> optional fields "external" <*> optional fields "image" <*> (fields .: "name") <*> optional fields "port" <*> optional fields "resources" <*> (fields .: "type") <*> (fields .: "user"))

instance ToJSON IssuerSpecDatabase where toJSON value = Object (KM.fromList (concat [optionalPair "external" (issuerSpecDatabaseExternal value), optionalPair "image" (issuerSpecDatabaseImage value), [("name", toJSON (issuerSpecDatabaseName value))], optionalPair "port" (issuerSpecDatabasePort value), optionalPair "resources" (issuerSpecDatabaseResources value), [("type", toJSON (issuerSpecDatabaseType value))], [("user", toJSON (issuerSpecDatabaseUser value))]]))

data IssuerSpecDatabaseExternal = IssuerSpecDatabaseExternal
  { issuerSpecDatabaseExternalHost :: Text,
    issuerSpecDatabaseExternalPassword :: SecretRef,
    issuerSpecDatabaseExternalPort :: Integer
  }
  deriving (Eq, Show)

instance FromJSON IssuerSpecDatabaseExternal where parseJSON = checked "IssuerSpecDatabaseExternal" $ withObject "IssuerSpecDatabaseExternal" (\fields -> IssuerSpecDatabaseExternal <$> (fields .: "host") <*> (fields .: "password") <*> (fields .: "port"))

instance ToJSON IssuerSpecDatabaseExternal where toJSON value = Object (KM.fromList (concat [[("host", toJSON (issuerSpecDatabaseExternalHost value))], [("password", toJSON (issuerSpecDatabaseExternalPassword value))], [("port", toJSON (issuerSpecDatabaseExternalPort value))]]))
