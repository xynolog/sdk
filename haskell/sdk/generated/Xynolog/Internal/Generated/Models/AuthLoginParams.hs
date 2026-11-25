-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AuthLoginParams (AuthLoginParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.Runtime
import Xynolog.Internal.Generated.Models.Target

data AuthLoginParams = AuthLoginParams
  { authLoginParamsApiVersion :: ApiVersion,
    authLoginParamsTarget :: Maybe Target,
    authLoginParamsRuntime :: Maybe Runtime
  }
  deriving (Eq, Show)

instance FromJSON AuthLoginParams where parseJSON = checked "AuthLoginParams" $ withObject "AuthLoginParams" (\fields -> AuthLoginParams <$> (fields .: "apiVersion") <*> optional fields "target" <*> optional fields "runtime")

instance ToJSON AuthLoginParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (authLoginParamsApiVersion value))], optionalPair "target" (authLoginParamsTarget value), optionalPair "runtime" (authLoginParamsRuntime value)]))
