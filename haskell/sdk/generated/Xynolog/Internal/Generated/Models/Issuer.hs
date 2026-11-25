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
  { issuerSpecType :: Text,
    issuerSpecImage :: Image,
    issuerSpecResources :: Resources,
    issuerSpecPort :: Integer,
    issuerSpecDatabase :: IssuerSpecDatabase
  }
  deriving (Eq, Show)

instance FromJSON IssuerSpec where parseJSON = checked "IssuerSpec" $ withObject "IssuerSpec" (\fields -> IssuerSpec <$> (fields .: "type") <*> (fields .: "image") <*> (fields .: "resources") <*> (fields .: "port") <*> (fields .: "database"))

instance ToJSON IssuerSpec where toJSON value = Object (KM.fromList (concat [[("type", toJSON (issuerSpecType value))], [("image", toJSON (issuerSpecImage value))], [("resources", toJSON (issuerSpecResources value))], [("port", toJSON (issuerSpecPort value))], [("database", toJSON (issuerSpecDatabase value))]]))

data IssuerSpecDatabase = IssuerSpecDatabase
  { issuerSpecDatabaseType :: Text,
    issuerSpecDatabaseName :: Text,
    issuerSpecDatabaseUser :: Text,
    issuerSpecDatabaseImage :: Maybe Image,
    issuerSpecDatabaseResources :: Maybe Resources,
    issuerSpecDatabasePort :: Maybe Integer,
    issuerSpecDatabaseExternal :: Maybe IssuerSpecDatabaseExternal
  }
  deriving (Eq, Show)

instance FromJSON IssuerSpecDatabase where parseJSON = checked "IssuerSpecDatabase" $ withObject "IssuerSpecDatabase" (\fields -> IssuerSpecDatabase <$> (fields .: "type") <*> (fields .: "name") <*> (fields .: "user") <*> optional fields "image" <*> optional fields "resources" <*> optional fields "port" <*> optional fields "external")

instance ToJSON IssuerSpecDatabase where toJSON value = Object (KM.fromList (concat [[("type", toJSON (issuerSpecDatabaseType value))], [("name", toJSON (issuerSpecDatabaseName value))], [("user", toJSON (issuerSpecDatabaseUser value))], optionalPair "image" (issuerSpecDatabaseImage value), optionalPair "resources" (issuerSpecDatabaseResources value), optionalPair "port" (issuerSpecDatabasePort value), optionalPair "external" (issuerSpecDatabaseExternal value)]))

data IssuerSpecDatabaseExternal = IssuerSpecDatabaseExternal
  { issuerSpecDatabaseExternalHost :: Text,
    issuerSpecDatabaseExternalPort :: Integer,
    issuerSpecDatabaseExternalPassword :: SecretRef
  }
  deriving (Eq, Show)

instance FromJSON IssuerSpecDatabaseExternal where parseJSON = checked "IssuerSpecDatabaseExternal" $ withObject "IssuerSpecDatabaseExternal" (\fields -> IssuerSpecDatabaseExternal <$> (fields .: "host") <*> (fields .: "port") <*> (fields .: "password"))

instance ToJSON IssuerSpecDatabaseExternal where toJSON value = Object (KM.fromList (concat [[("host", toJSON (issuerSpecDatabaseExternalHost value))], [("port", toJSON (issuerSpecDatabaseExternalPort value))], [("password", toJSON (issuerSpecDatabaseExternalPassword value))]]))
