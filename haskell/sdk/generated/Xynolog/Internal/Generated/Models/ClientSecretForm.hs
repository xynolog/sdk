-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ClientSecretForm (ClientSecretForm (..), ClientSecretFormGrantType (..), clientSecretFormGrantTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ClientSecretForm = ClientSecretForm
  { clientSecretFormGrantType :: ClientSecretFormGrantType,
    clientSecretFormClientId :: Text,
    clientSecretFormClientSecret :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientSecretForm where parseJSON = checked "ClientSecretForm" $ withObject "ClientSecretForm" (\fields -> ClientSecretForm <$> (fields .: "grant_type") <*> (fields .: "client_id") <*> (fields .: "client_secret"))

instance ToJSON ClientSecretForm where toJSON value = Object (KM.fromList (concat [[("grant_type", toJSON (clientSecretFormGrantType value))], [("client_id", toJSON (clientSecretFormClientId value))], [("client_secret", toJSON (clientSecretFormClientSecret value))]]))

data ClientSecretFormGrantType = ClientSecretFormGrantTypeClientCredentials deriving (Eq, Show)

instance FromJSON ClientSecretFormGrantType where parseJSON = checked "ClientSecretFormGrantType" $ \value -> if value == String "client_credentials" then pure ClientSecretFormGrantTypeClientCredentials else fail "unknown enumeration member"

instance ToJSON ClientSecretFormGrantType where toJSON ClientSecretFormGrantTypeClientCredentials = String "client_credentials"

clientSecretFormGrantTypeText :: ClientSecretFormGrantType -> Text
clientSecretFormGrantTypeText ClientSecretFormGrantTypeClientCredentials = "client_credentials"
