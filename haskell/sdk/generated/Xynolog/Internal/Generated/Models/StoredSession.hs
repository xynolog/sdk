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
    storedSessionClientId :: Text,
    storedSessionPersonKey :: Maybe Text,
    storedSessionRefresh :: Text,
    storedSessionRevocationEndpoint :: Maybe Text,
    storedSessionTokenEndpoint :: Text
  }
  deriving (Eq, Show)

instance FromJSON StoredSession where parseJSON = checked "StoredSession" $ withObject "StoredSession" (\fields -> StoredSession <$> (fields .: "access") <*> (fields .: "clientId") <*> optional fields "personKey" <*> (fields .: "refresh") <*> optional fields "revocationEndpoint" <*> (fields .: "tokenEndpoint"))

instance ToJSON StoredSession where toJSON value = Object (KM.fromList (concat [[("access", toJSON (storedSessionAccess value))], [("clientId", toJSON (storedSessionClientId value))], optionalPair "personKey" (storedSessionPersonKey value), [("refresh", toJSON (storedSessionRefresh value))], optionalPair "revocationEndpoint" (storedSessionRevocationEndpoint value), [("tokenEndpoint", toJSON (storedSessionTokenEndpoint value))]]))
