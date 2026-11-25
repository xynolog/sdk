-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.PendingAuthorization (PendingAuthorization (..), PendingAuthorizationIssuer (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HttpEndpoint

data PendingAuthorization = PendingAuthorization
  { pendingAuthorizationExpectedDid :: Maybe Text,
    pendingAuthorizationExpectedName :: Maybe Text,
    pendingAuthorizationIssuer :: PendingAuthorizationIssuer,
    pendingAuthorizationKbId :: Maybe Text,
    pendingAuthorizationRedirectUri :: Text,
    pendingAuthorizationState :: Text,
    pendingAuthorizationTarget :: HttpEndpoint,
    pendingAuthorizationVerifier :: Text
  }
  deriving (Eq, Show)

instance FromJSON PendingAuthorization where parseJSON = checked "PendingAuthorization" $ withObject "PendingAuthorization" (\fields -> PendingAuthorization <$> optional fields "expectedDid" <*> optional fields "expectedName" <*> (fields .: "issuer") <*> optional fields "kbId" <*> (fields .: "redirectUri") <*> (fields .: "state") <*> (fields .: "target") <*> (fields .: "verifier"))

instance ToJSON PendingAuthorization where toJSON value = Object (KM.fromList (concat [optionalPair "expectedDid" (pendingAuthorizationExpectedDid value), optionalPair "expectedName" (pendingAuthorizationExpectedName value), [("issuer", toJSON (pendingAuthorizationIssuer value))], optionalPair "kbId" (pendingAuthorizationKbId value), [("redirectUri", toJSON (pendingAuthorizationRedirectUri value))], [("state", toJSON (pendingAuthorizationState value))], [("target", toJSON (pendingAuthorizationTarget value))], [("verifier", toJSON (pendingAuthorizationVerifier value))]]))

data PendingAuthorizationIssuer = PendingAuthorizationIssuer
  { pendingAuthorizationIssuerAuthorization :: Text,
    pendingAuthorizationIssuerDevice :: Maybe Text,
    pendingAuthorizationIssuerIssuer :: Text,
    pendingAuthorizationIssuerRevocation :: Maybe Text,
    pendingAuthorizationIssuerToken :: Text
  }
  deriving (Eq, Show)

instance FromJSON PendingAuthorizationIssuer where parseJSON = checked "PendingAuthorizationIssuer" $ withObject "PendingAuthorizationIssuer" (\fields -> PendingAuthorizationIssuer <$> (fields .: "authorization") <*> optional fields "device" <*> (fields .: "issuer") <*> optional fields "revocation" <*> (fields .: "token"))

instance ToJSON PendingAuthorizationIssuer where toJSON value = Object (KM.fromList (concat [[("authorization", toJSON (pendingAuthorizationIssuerAuthorization value))], optionalPair "device" (pendingAuthorizationIssuerDevice value), [("issuer", toJSON (pendingAuthorizationIssuerIssuer value))], optionalPair "revocation" (pendingAuthorizationIssuerRevocation value), [("token", toJSON (pendingAuthorizationIssuerToken value))]]))
