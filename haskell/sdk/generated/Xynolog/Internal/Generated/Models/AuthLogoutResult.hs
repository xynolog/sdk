-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AuthLogoutResult (AuthLogoutResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AuthLogoutResult = AuthLogoutResult
  { authLogoutResultKey :: Maybe Text,
    authLogoutResultRevoked :: Bool,
    authLogoutResultWasSignedIn :: Bool
  }
  deriving (Eq, Show)

instance FromJSON AuthLogoutResult where parseJSON = checked "AuthLogoutResult" $ withObject "AuthLogoutResult" (\fields -> AuthLogoutResult <$> optional fields "key" <*> (fields .: "revoked") <*> (fields .: "wasSignedIn"))

instance ToJSON AuthLogoutResult where toJSON value = Object (KM.fromList (concat [optionalPair "key" (authLogoutResultKey value), [("revoked", toJSON (authLogoutResultRevoked value))], [("wasSignedIn", toJSON (authLogoutResultWasSignedIn value))]]))
