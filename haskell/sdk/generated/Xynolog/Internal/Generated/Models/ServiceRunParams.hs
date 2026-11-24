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
    serviceRunParamsArgs :: Maybe [Text],
    serviceRunParamsDocument :: Maybe Text,
    serviceRunParamsEnvironment :: ServiceRunParamsEnvironment,
    serviceRunParamsInstance :: RunInstance,
    serviceRunParamsMounts :: [Text],
    serviceRunParamsPathFirst :: [Text],
    serviceRunParamsPorts :: [Integer],
    serviceRunParamsRuntime :: Maybe Runtime,
    serviceRunParamsService :: RunService,
    serviceRunParamsTarget :: LocalTarget
  }
  deriving (Eq, Show)

instance FromJSON ServiceRunParams where parseJSON = checked "ServiceRunParams" $ withObject "ServiceRunParams" (\fields -> ServiceRunParams <$> (fields .: "apiVersion") <*> optional fields "args" <*> optional fields "document" <*> (fields .: "environment") <*> (fields .: "instance") <*> (fields .: "mounts") <*> (fields .: "pathFirst") <*> (fields .: "ports") <*> optional fields "runtime" <*> (fields .: "service") <*> (fields .: "target"))

instance ToJSON ServiceRunParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (serviceRunParamsApiVersion value))], optionalPair "args" (serviceRunParamsArgs value), optionalPair "document" (serviceRunParamsDocument value), [("environment", toJSON (serviceRunParamsEnvironment value))], [("instance", toJSON (serviceRunParamsInstance value))], [("mounts", toJSON (serviceRunParamsMounts value))], [("pathFirst", toJSON (serviceRunParamsPathFirst value))], [("ports", toJSON (serviceRunParamsPorts value))], optionalPair "runtime" (serviceRunParamsRuntime value), [("service", toJSON (serviceRunParamsService value))], [("target", toJSON (serviceRunParamsTarget value))]]))

data ServiceRunParamsEnvironment = ServiceRunParamsEnvironment
  { serviceRunParamsEnvironmentAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceRunParamsEnvironment where parseJSON = checked "ServiceRunParamsEnvironment" $ withObject "ServiceRunParamsEnvironment" (\fields -> ServiceRunParamsEnvironment <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ServiceRunParamsEnvironment where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (serviceRunParamsEnvironmentAdditionalProperties value)))
