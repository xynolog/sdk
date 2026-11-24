-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StackStopParams (StackStopParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.Runtime
import Xynolog.Internal.Generated.Models.ServiceGroup
import Xynolog.Internal.Generated.Models.Target

data StackStopParams = StackStopParams
  { stackStopParamsApiVersion :: ApiVersion,
    stackStopParamsDelete :: Maybe Bool,
    stackStopParamsDeleteConfirmed :: Maybe Bool,
    stackStopParamsDryRun :: Maybe Bool,
    stackStopParamsGroup :: Maybe ServiceGroup,
    stackStopParamsRuntime :: Maybe Runtime,
    stackStopParamsService :: Maybe Text,
    stackStopParamsTarget :: Maybe Target
  }
  deriving (Eq, Show)

instance FromJSON StackStopParams where parseJSON = checked "StackStopParams" $ withObject "StackStopParams" (\fields -> StackStopParams <$> (fields .: "apiVersion") <*> optional fields "delete" <*> optional fields "deleteConfirmed" <*> optional fields "dryRun" <*> optional fields "group" <*> optional fields "runtime" <*> optional fields "service" <*> optional fields "target")

instance ToJSON StackStopParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (stackStopParamsApiVersion value))], optionalPair "delete" (stackStopParamsDelete value), optionalPair "deleteConfirmed" (stackStopParamsDeleteConfirmed value), optionalPair "dryRun" (stackStopParamsDryRun value), optionalPair "group" (stackStopParamsGroup value), optionalPair "runtime" (stackStopParamsRuntime value), optionalPair "service" (stackStopParamsService value), optionalPair "target" (stackStopParamsTarget value)]))
