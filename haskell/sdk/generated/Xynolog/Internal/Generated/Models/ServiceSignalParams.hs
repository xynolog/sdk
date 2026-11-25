-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceSignalParams (ServiceSignalParams (..), ServiceSignalParamsSignal (..), serviceSignalParamsSignalText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.LocalTarget
import Xynolog.Internal.Generated.Models.RunInstance
import Xynolog.Internal.Generated.Models.Runtime

data ServiceSignalParams = ServiceSignalParams
  { serviceSignalParamsApiVersion :: ApiVersion,
    serviceSignalParamsTarget :: LocalTarget,
    serviceSignalParamsRuntime :: Maybe Runtime,
    serviceSignalParamsInstance :: RunInstance,
    serviceSignalParamsSignal :: ServiceSignalParamsSignal
  }
  deriving (Eq, Show)

instance FromJSON ServiceSignalParams where parseJSON = checked "ServiceSignalParams" $ withObject "ServiceSignalParams" (\fields -> ServiceSignalParams <$> (fields .: "apiVersion") <*> (fields .: "target") <*> optional fields "runtime" <*> (fields .: "instance") <*> (fields .: "signal"))

instance ToJSON ServiceSignalParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (serviceSignalParamsApiVersion value))], [("target", toJSON (serviceSignalParamsTarget value))], optionalPair "runtime" (serviceSignalParamsRuntime value), [("instance", toJSON (serviceSignalParamsInstance value))], [("signal", toJSON (serviceSignalParamsSignal value))]]))

data ServiceSignalParamsSignal = ServiceSignalParamsSignalTerm | ServiceSignalParamsSignalKill deriving (Eq, Show)

instance FromJSON ServiceSignalParamsSignal where parseJSON = checked "ServiceSignalParamsSignal" $ \value -> if value == String "term" then pure ServiceSignalParamsSignalTerm else if value == String "kill" then pure ServiceSignalParamsSignalKill else fail "unknown enumeration member"

instance ToJSON ServiceSignalParamsSignal where
  toJSON ServiceSignalParamsSignalTerm = String "term"
  toJSON ServiceSignalParamsSignalKill = String "kill"

serviceSignalParamsSignalText :: ServiceSignalParamsSignal -> Text
serviceSignalParamsSignalText ServiceSignalParamsSignalTerm = "term"
serviceSignalParamsSignalText ServiceSignalParamsSignalKill = "kill"
