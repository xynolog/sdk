-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BeginAuthorizationOptions (BeginAuthorizationOptions (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HttpEndpoint

data BeginAuthorizationOptions = BeginAuthorizationOptions
  { beginAuthorizationOptionsTarget :: HttpEndpoint,
    beginAuthorizationOptionsRedirectUri :: Text,
    beginAuthorizationOptionsKbId :: Maybe Text,
    beginAuthorizationOptionsExpectedDid :: Maybe Text,
    beginAuthorizationOptionsExpectedName :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON BeginAuthorizationOptions where parseJSON = checked "BeginAuthorizationOptions" $ withObject "BeginAuthorizationOptions" (\fields -> BeginAuthorizationOptions <$> (fields .: "target") <*> (fields .: "redirectUri") <*> optional fields "kbId" <*> optional fields "expectedDid" <*> optional fields "expectedName")

instance ToJSON BeginAuthorizationOptions where toJSON value = Object (KM.fromList (concat [[("target", toJSON (beginAuthorizationOptionsTarget value))], [("redirectUri", toJSON (beginAuthorizationOptionsRedirectUri value))], optionalPair "kbId" (beginAuthorizationOptionsKbId value), optionalPair "expectedDid" (beginAuthorizationOptionsExpectedDid value), optionalPair "expectedName" (beginAuthorizationOptionsExpectedName value)]))
