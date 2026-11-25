-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ClientSecretForm (ClientSecretForm (..), ClientSecretFormGrantType (..), clientSecretFormGrantTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ClientSecretForm = ClientSecretForm
  { clientSecretFormClientId :: Text,
    clientSecretFormClientSecret :: Text,
    clientSecretFormGrantType :: ClientSecretFormGrantType
  }
  deriving (Eq, Show)

instance FromJSON ClientSecretForm where parseJSON = checked "ClientSecretForm" $ withObject "ClientSecretForm" (\fields -> ClientSecretForm <$> (fields .: "client_id") <*> (fields .: "client_secret") <*> (fields .: "grant_type"))

instance ToJSON ClientSecretForm where toJSON value = Object (KM.fromList (concat [[("client_id", toJSON (clientSecretFormClientId value))], [("client_secret", toJSON (clientSecretFormClientSecret value))], [("grant_type", toJSON (clientSecretFormGrantType value))]]))

data ClientSecretFormGrantType = ClientSecretFormGrantTypeClientCredentials deriving (Eq, Show)

instance FromJSON ClientSecretFormGrantType where parseJSON = checked "ClientSecretFormGrantType" $ \value -> if value == String "client_credentials" then pure ClientSecretFormGrantTypeClientCredentials else fail "unknown enumeration member"

instance ToJSON ClientSecretFormGrantType where toJSON ClientSecretFormGrantTypeClientCredentials = String "client_credentials"

clientSecretFormGrantTypeText :: ClientSecretFormGrantType -> Text
clientSecretFormGrantTypeText ClientSecretFormGrantTypeClientCredentials = "client_credentials"
