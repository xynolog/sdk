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
    stackStopParamsTarget :: Maybe Target,
    stackStopParamsRuntime :: Maybe Runtime,
    stackStopParamsService :: Maybe Text,
    stackStopParamsGroup :: Maybe ServiceGroup,
    stackStopParamsDelete :: Maybe Bool,
    stackStopParamsDeleteConfirmed :: Maybe Bool,
    stackStopParamsDryRun :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON StackStopParams where parseJSON = checked "StackStopParams" $ withObject "StackStopParams" (\fields -> StackStopParams <$> (fields .: "apiVersion") <*> optional fields "target" <*> optional fields "runtime" <*> optional fields "service" <*> optional fields "group" <*> optional fields "delete" <*> optional fields "deleteConfirmed" <*> optional fields "dryRun")

instance ToJSON StackStopParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (stackStopParamsApiVersion value))], optionalPair "target" (stackStopParamsTarget value), optionalPair "runtime" (stackStopParamsRuntime value), optionalPair "service" (stackStopParamsService value), optionalPair "group" (stackStopParamsGroup value), optionalPair "delete" (stackStopParamsDelete value), optionalPair "deleteConfirmed" (stackStopParamsDeleteConfirmed value), optionalPair "dryRun" (stackStopParamsDryRun value)]))
