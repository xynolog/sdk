-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceSignalParams (ServiceSignalParams (..), ServiceSignalParamsSignal (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.LocalTarget
import Xynolog.Internal.Generated.Models.RunInstance
import Xynolog.Internal.Generated.Models.Runtime

data ServiceSignalParams = ServiceSignalParams
  { serviceSignalParamsApiVersion :: ApiVersion,
    serviceSignalParamsInstance :: RunInstance,
    serviceSignalParamsRuntime :: Maybe Runtime,
    serviceSignalParamsSignal :: ServiceSignalParamsSignal,
    serviceSignalParamsTarget :: LocalTarget
  }
  deriving (Eq, Show)

instance FromJSON ServiceSignalParams where parseJSON = checked "ServiceSignalParams" $ withObject "ServiceSignalParams" (\fields -> ServiceSignalParams <$> (fields .: "apiVersion") <*> (fields .: "instance") <*> optional fields "runtime" <*> (fields .: "signal") <*> (fields .: "target"))

instance ToJSON ServiceSignalParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (serviceSignalParamsApiVersion value))], [("instance", toJSON (serviceSignalParamsInstance value))], optionalPair "runtime" (serviceSignalParamsRuntime value), [("signal", toJSON (serviceSignalParamsSignal value))], [("target", toJSON (serviceSignalParamsTarget value))]]))

data ServiceSignalParamsSignal = ServiceSignalParamsSignalTerm | ServiceSignalParamsSignalKill deriving (Eq, Show)

instance FromJSON ServiceSignalParamsSignal where parseJSON = checked "ServiceSignalParamsSignal" $ \value -> if value == String "term" then pure ServiceSignalParamsSignalTerm else if value == String "kill" then pure ServiceSignalParamsSignalKill else fail "unknown enumeration member"

instance ToJSON ServiceSignalParamsSignal where
  toJSON ServiceSignalParamsSignalTerm = String "term"
  toJSON ServiceSignalParamsSignalKill = String "kill"
