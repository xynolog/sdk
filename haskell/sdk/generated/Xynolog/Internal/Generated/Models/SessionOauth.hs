-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SessionOauth (SessionOauth (..), SessionOauthClientsItem (..), SessionOauthScopes (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SessionOauth = SessionOauth
  { sessionOauthComment :: Text,
    sessionOauthClients :: [SessionOauthClientsItem],
    sessionOauthScopes :: SessionOauthScopes
  }
  deriving (Eq, Show)

instance FromJSON SessionOauth where parseJSON = checked "SessionOauth" $ withObject "SessionOauth" (\fields -> SessionOauth <$> (fields .: "$comment") <*> (fields .: "clients") <*> (fields .: "scopes"))

instance ToJSON SessionOauth where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (sessionOauthComment value))], [("clients", toJSON (sessionOauthClients value))], [("scopes", toJSON (sessionOauthScopes value))]]))

data SessionOauthClientsItem = SessionOauthClientsItem
  { sessionOauthClientsItemName :: Text,
    sessionOauthClientsItemId :: Text,
    sessionOauthClientsItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON SessionOauthClientsItem where parseJSON = checked "SessionOauthClientsItem" $ withObject "SessionOauthClientsItem" (\fields -> SessionOauthClientsItem <$> (fields .: "name") <*> (fields .: "id") <*> (fields .: "docs"))

instance ToJSON SessionOauthClientsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (sessionOauthClientsItemName value))], [("id", toJSON (sessionOauthClientsItemId value))], [("docs", toJSON (sessionOauthClientsItemDocs value))]]))

data SessionOauthScopes = SessionOauthScopes
  { sessionOauthScopesValue :: Text,
    sessionOauthScopesDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON SessionOauthScopes where parseJSON = checked "SessionOauthScopes" $ withObject "SessionOauthScopes" (\fields -> SessionOauthScopes <$> (fields .: "value") <*> (fields .: "docs"))

instance ToJSON SessionOauthScopes where toJSON value = Object (KM.fromList (concat [[("value", toJSON (sessionOauthScopesValue value))], [("docs", toJSON (sessionOauthScopesDocs value))]]))
