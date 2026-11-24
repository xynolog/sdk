-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AuthLoginResult (AuthLoginResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AuthLoginResult = AuthLoginResult
  { authLoginResultIssuer :: Text,
    authLoginResultKey :: Text,
    authLoginResultWho :: Text
  }
  deriving (Eq, Show)

instance FromJSON AuthLoginResult where parseJSON = checked "AuthLoginResult" $ withObject "AuthLoginResult" (\fields -> AuthLoginResult <$> (fields .: "issuer") <*> (fields .: "key") <*> (fields .: "who"))

instance ToJSON AuthLoginResult where toJSON value = Object (KM.fromList (concat [[("issuer", toJSON (authLoginResultIssuer value))], [("key", toJSON (authLoginResultKey value))], [("who", toJSON (authLoginResultWho value))]]))
