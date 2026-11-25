-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SignIn (SignIn (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SignIn = SignIn
  { signInEmail :: Maybe Text,
    signInExpiresAt :: Maybe Text,
    signInIssuer :: Text,
    signInObtainedAt :: Text,
    signInRefreshToken :: Maybe Text,
    signInRevocationEndpoint :: Maybe Text,
    signInToken :: Text,
    signInTokenEndpoint :: Text
  }
  deriving (Eq, Show)

instance FromJSON SignIn where parseJSON = checked "SignIn" $ withObject "SignIn" (\fields -> SignIn <$> optional fields "email" <*> optional fields "expiresAt" <*> (fields .: "issuer") <*> (fields .: "obtainedAt") <*> optional fields "refreshToken" <*> optional fields "revocationEndpoint" <*> (fields .: "token") <*> (fields .: "tokenEndpoint"))

instance ToJSON SignIn where toJSON value = Object (KM.fromList (concat [optionalPair "email" (signInEmail value), optionalPair "expiresAt" (signInExpiresAt value), [("issuer", toJSON (signInIssuer value))], [("obtainedAt", toJSON (signInObtainedAt value))], optionalPair "refreshToken" (signInRefreshToken value), optionalPair "revocationEndpoint" (signInRevocationEndpoint value), [("token", toJSON (signInToken value))], [("tokenEndpoint", toJSON (signInTokenEndpoint value))]]))
