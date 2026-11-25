-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SignIn (SignIn (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SignIn = SignIn
  { signInToken :: Text,
    signInRefreshToken :: Maybe Text,
    signInEmail :: Maybe Text,
    signInObtainedAt :: Text,
    signInExpiresAt :: Maybe Text,
    signInIssuer :: Text,
    signInTokenEndpoint :: Text,
    signInRevocationEndpoint :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON SignIn where parseJSON = checked "SignIn" $ withObject "SignIn" (\fields -> SignIn <$> (fields .: "token") <*> optional fields "refreshToken" <*> optional fields "email" <*> (fields .: "obtainedAt") <*> optional fields "expiresAt" <*> (fields .: "issuer") <*> (fields .: "tokenEndpoint") <*> optional fields "revocationEndpoint")

instance ToJSON SignIn where toJSON value = Object (KM.fromList (concat [[("token", toJSON (signInToken value))], optionalPair "refreshToken" (signInRefreshToken value), optionalPair "email" (signInEmail value), [("obtainedAt", toJSON (signInObtainedAt value))], optionalPair "expiresAt" (signInExpiresAt value), [("issuer", toJSON (signInIssuer value))], [("tokenEndpoint", toJSON (signInTokenEndpoint value))], optionalPair "revocationEndpoint" (signInRevocationEndpoint value)]))
