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
  { pendingAuthorizationState :: Text,
    pendingAuthorizationVerifier :: Text,
    pendingAuthorizationRedirectUri :: Text,
    pendingAuthorizationTarget :: HttpEndpoint,
    pendingAuthorizationIssuer :: PendingAuthorizationIssuer,
    pendingAuthorizationKbId :: Maybe Text,
    pendingAuthorizationExpectedDid :: Maybe Text,
    pendingAuthorizationExpectedName :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON PendingAuthorization where parseJSON = checked "PendingAuthorization" $ withObject "PendingAuthorization" (\fields -> PendingAuthorization <$> (fields .: "state") <*> (fields .: "verifier") <*> (fields .: "redirectUri") <*> (fields .: "target") <*> (fields .: "issuer") <*> optional fields "kbId" <*> optional fields "expectedDid" <*> optional fields "expectedName")

instance ToJSON PendingAuthorization where toJSON value = Object (KM.fromList (concat [[("state", toJSON (pendingAuthorizationState value))], [("verifier", toJSON (pendingAuthorizationVerifier value))], [("redirectUri", toJSON (pendingAuthorizationRedirectUri value))], [("target", toJSON (pendingAuthorizationTarget value))], [("issuer", toJSON (pendingAuthorizationIssuer value))], optionalPair "kbId" (pendingAuthorizationKbId value), optionalPair "expectedDid" (pendingAuthorizationExpectedDid value), optionalPair "expectedName" (pendingAuthorizationExpectedName value)]))

data PendingAuthorizationIssuer = PendingAuthorizationIssuer
  { pendingAuthorizationIssuerIssuer :: Text,
    pendingAuthorizationIssuerAuthorization :: Text,
    pendingAuthorizationIssuerToken :: Text,
    pendingAuthorizationIssuerDevice :: Maybe Text,
    pendingAuthorizationIssuerRevocation :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON PendingAuthorizationIssuer where parseJSON = checked "PendingAuthorizationIssuer" $ withObject "PendingAuthorizationIssuer" (\fields -> PendingAuthorizationIssuer <$> (fields .: "issuer") <*> (fields .: "authorization") <*> (fields .: "token") <*> optional fields "device" <*> optional fields "revocation")

instance ToJSON PendingAuthorizationIssuer where toJSON value = Object (KM.fromList (concat [[("issuer", toJSON (pendingAuthorizationIssuerIssuer value))], [("authorization", toJSON (pendingAuthorizationIssuerAuthorization value))], [("token", toJSON (pendingAuthorizationIssuerToken value))], optionalPair "device" (pendingAuthorizationIssuerDevice value), optionalPair "revocation" (pendingAuthorizationIssuerRevocation value)]))
