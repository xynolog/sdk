-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ClientSecretForm (ClientSecretForm (..), ClientSecretFormGrantU5f_type (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ClientSecretForm = ClientSecretForm
  { clientSecretFormClientU5f_id :: Text,
    clientSecretFormClientU5f_secret :: Text,
    clientSecretFormGrantU5f_type :: ClientSecretFormGrantU5f_type,
    clientSecretFormAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ClientSecretForm where parseJSON = checked "ClientSecretForm" $ withObject "ClientSecretForm" (\fields -> ClientSecretForm <$> (fields .: "client_id") <*> (fields .: "client_secret") <*> (fields .: "grant_type") <*> traverse parseJSON (withoutFields ["client_id", "client_secret", "grant_type"] fields))

instance ToJSON ClientSecretForm where toJSON value = Object (KM.fromList (concat [[("client_id", toJSON (clientSecretFormClientU5f_id value))], [("client_secret", toJSON (clientSecretFormClientU5f_secret value))], [("grant_type", toJSON (clientSecretFormGrantU5f_type value))]]) <> fmap toJSON (withoutFields ["client_id", "client_secret", "grant_type"] (clientSecretFormAdditionalProperties value)))

data ClientSecretFormGrantU5f_type = ClientSecretFormGrantU5f_typeClientU5f_credentials deriving (Eq, Show)

instance FromJSON ClientSecretFormGrantU5f_type where parseJSON = checked "ClientSecretFormGrantU5f_type" $ \value -> if value == String "client_credentials" then pure ClientSecretFormGrantU5f_typeClientU5f_credentials else fail "unknown enumeration member"

instance ToJSON ClientSecretFormGrantU5f_type where toJSON ClientSecretFormGrantU5f_typeClientU5f_credentials = String "client_credentials"
