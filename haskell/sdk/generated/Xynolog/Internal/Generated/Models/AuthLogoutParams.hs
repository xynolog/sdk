-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AuthLogoutParams (AuthLogoutParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.Runtime
import Xynolog.Internal.Generated.Models.Target

data AuthLogoutParams = AuthLogoutParams
  { authLogoutParamsApiVersion :: ApiVersion,
    authLogoutParamsTarget :: Maybe Target,
    authLogoutParamsRuntime :: Maybe Runtime
  }
  deriving (Eq, Show)

instance FromJSON AuthLogoutParams where parseJSON = checked "AuthLogoutParams" $ withObject "AuthLogoutParams" (\fields -> AuthLogoutParams <$> (fields .: "apiVersion") <*> optional fields "target" <*> optional fields "runtime")

instance ToJSON AuthLogoutParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (authLogoutParamsApiVersion value))], optionalPair "target" (authLogoutParamsTarget value), optionalPair "runtime" (authLogoutParamsRuntime value)]))
