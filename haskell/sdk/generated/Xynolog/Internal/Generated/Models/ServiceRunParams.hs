-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceRunParams (ServiceRunParams (..), ServiceRunParamsEnvironment (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.LocalTarget
import Xynolog.Internal.Generated.Models.RunInstance
import Xynolog.Internal.Generated.Models.RunService
import Xynolog.Internal.Generated.Models.Runtime

data ServiceRunParams = ServiceRunParams
  { serviceRunParamsApiVersion :: ApiVersion,
    serviceRunParamsTarget :: LocalTarget,
    serviceRunParamsRuntime :: Maybe Runtime,
    serviceRunParamsService :: RunService,
    serviceRunParamsInstance :: RunInstance,
    serviceRunParamsDocument :: Maybe Text,
    serviceRunParamsArgs :: Maybe [Text],
    serviceRunParamsEnvironment :: ServiceRunParamsEnvironment,
    serviceRunParamsMounts :: [Text],
    serviceRunParamsPathFirst :: [Text],
    serviceRunParamsPorts :: [Integer]
  }
  deriving (Eq, Show)

instance FromJSON ServiceRunParams where parseJSON = checked "ServiceRunParams" $ withObject "ServiceRunParams" (\fields -> ServiceRunParams <$> (fields .: "apiVersion") <*> (fields .: "target") <*> optional fields "runtime" <*> (fields .: "service") <*> (fields .: "instance") <*> optional fields "document" <*> optional fields "args" <*> (fields .: "environment") <*> (fields .: "mounts") <*> (fields .: "pathFirst") <*> (fields .: "ports"))

instance ToJSON ServiceRunParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (serviceRunParamsApiVersion value))], [("target", toJSON (serviceRunParamsTarget value))], optionalPair "runtime" (serviceRunParamsRuntime value), [("service", toJSON (serviceRunParamsService value))], [("instance", toJSON (serviceRunParamsInstance value))], optionalPair "document" (serviceRunParamsDocument value), optionalPair "args" (serviceRunParamsArgs value), [("environment", toJSON (serviceRunParamsEnvironment value))], [("mounts", toJSON (serviceRunParamsMounts value))], [("pathFirst", toJSON (serviceRunParamsPathFirst value))], [("ports", toJSON (serviceRunParamsPorts value))]]))

data ServiceRunParamsEnvironment = ServiceRunParamsEnvironment
  { serviceRunParamsEnvironmentAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceRunParamsEnvironment where parseJSON = checked "ServiceRunParamsEnvironment" $ withObject "ServiceRunParamsEnvironment" (\fields -> ServiceRunParamsEnvironment <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ServiceRunParamsEnvironment where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (serviceRunParamsEnvironmentAdditionalProperties value)))
