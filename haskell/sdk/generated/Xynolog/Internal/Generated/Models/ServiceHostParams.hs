-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceHostParams (ServiceHostParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.Runtime

data ServiceHostParams = ServiceHostParams
  { serviceHostParamsApiVersion :: ApiVersion,
    serviceHostParamsRuntime :: Maybe Runtime
  }
  deriving (Eq, Show)

instance FromJSON ServiceHostParams where parseJSON = checked "ServiceHostParams" $ withObject "ServiceHostParams" (\fields -> ServiceHostParams <$> (fields .: "apiVersion") <*> optional fields "runtime")

instance ToJSON ServiceHostParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (serviceHostParamsApiVersion value))], optionalPair "runtime" (serviceHostParamsRuntime value)]))
