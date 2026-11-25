-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StoredSession (StoredSession (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data StoredSession = StoredSession
  { storedSessionAccess :: Text,
    storedSessionRefresh :: Text,
    storedSessionClientId :: Text,
    storedSessionTokenEndpoint :: Text,
    storedSessionRevocationEndpoint :: Maybe Text,
    storedSessionPersonKey :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON StoredSession where parseJSON = checked "StoredSession" $ withObject "StoredSession" (\fields -> StoredSession <$> (fields .: "access") <*> (fields .: "refresh") <*> (fields .: "clientId") <*> (fields .: "tokenEndpoint") <*> optional fields "revocationEndpoint" <*> optional fields "personKey")

instance ToJSON StoredSession where toJSON value = Object (KM.fromList (concat [[("access", toJSON (storedSessionAccess value))], [("refresh", toJSON (storedSessionRefresh value))], [("clientId", toJSON (storedSessionClientId value))], [("tokenEndpoint", toJSON (storedSessionTokenEndpoint value))], optionalPair "revocationEndpoint" (storedSessionRevocationEndpoint value), optionalPair "personKey" (storedSessionPersonKey value)]))
