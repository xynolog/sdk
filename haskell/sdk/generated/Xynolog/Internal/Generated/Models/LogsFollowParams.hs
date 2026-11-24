-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LogsFollowParams (LogsFollowParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.Runtime
import Xynolog.Internal.Generated.Models.Target

data LogsFollowParams = LogsFollowParams
  { logsFollowParamsApiVersion :: ApiVersion,
    logsFollowParamsRuntime :: Maybe Runtime,
    logsFollowParamsService :: Maybe Text,
    logsFollowParamsTarget :: Maybe Target
  }
  deriving (Eq, Show)

instance FromJSON LogsFollowParams where parseJSON = checked "LogsFollowParams" $ withObject "LogsFollowParams" (\fields -> LogsFollowParams <$> (fields .: "apiVersion") <*> optional fields "runtime" <*> optional fields "service" <*> optional fields "target")

instance ToJSON LogsFollowParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (logsFollowParamsApiVersion value))], optionalPair "runtime" (logsFollowParamsRuntime value), optionalPair "service" (logsFollowParamsService value), optionalPair "target" (logsFollowParamsTarget value)]))
