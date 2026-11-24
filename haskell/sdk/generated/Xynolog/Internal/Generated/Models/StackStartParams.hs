-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StackStartParams (StackStartParams (..), StackStartParamsOllamaCache (..), stackStartParamsOllamaCacheText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.Runtime
import Xynolog.Internal.Generated.Models.ServiceGroup
import Xynolog.Internal.Generated.Models.Target

data StackStartParams = StackStartParams
  { stackStartParamsApiVersion :: ApiVersion,
    stackStartParamsCodespaceName :: Maybe Text,
    stackStartParamsConfig :: Maybe Text,
    stackStartParamsDryRun :: Maybe Bool,
    stackStartParamsGroup :: Maybe ServiceGroup,
    stackStartParamsIdleTimeout :: Maybe Text,
    stackStartParamsMachine :: Maybe Text,
    stackStartParamsObserve :: Maybe Bool,
    stackStartParamsOllamaCache :: Maybe StackStartParamsOllamaCache,
    stackStartParamsRetentionPeriod :: Maybe Text,
    stackStartParamsRuntime :: Maybe Runtime,
    stackStartParamsService :: Maybe Text,
    stackStartParamsTarget :: Maybe Target
  }
  deriving (Eq, Show)

instance FromJSON StackStartParams where parseJSON = checked "StackStartParams" $ withObject "StackStartParams" (\fields -> StackStartParams <$> (fields .: "apiVersion") <*> optional fields "codespaceName" <*> optional fields "config" <*> optional fields "dryRun" <*> optional fields "group" <*> optional fields "idleTimeout" <*> optional fields "machine" <*> optional fields "observe" <*> optional fields "ollamaCache" <*> optional fields "retentionPeriod" <*> optional fields "runtime" <*> optional fields "service" <*> optional fields "target")

instance ToJSON StackStartParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (stackStartParamsApiVersion value))], optionalPair "codespaceName" (stackStartParamsCodespaceName value), optionalPair "config" (stackStartParamsConfig value), optionalPair "dryRun" (stackStartParamsDryRun value), optionalPair "group" (stackStartParamsGroup value), optionalPair "idleTimeout" (stackStartParamsIdleTimeout value), optionalPair "machine" (stackStartParamsMachine value), optionalPair "observe" (stackStartParamsObserve value), optionalPair "ollamaCache" (stackStartParamsOllamaCache value), optionalPair "retentionPeriod" (stackStartParamsRetentionPeriod value), optionalPair "runtime" (stackStartParamsRuntime value), optionalPair "service" (stackStartParamsService value), optionalPair "target" (stackStartParamsTarget value)]))

data StackStartParamsOllamaCache = StackStartParamsOllamaCacheHost | StackStartParamsOllamaCacheVolume deriving (Eq, Show)

instance FromJSON StackStartParamsOllamaCache where parseJSON = checked "StackStartParamsOllamaCache" $ \value -> if value == String "host" then pure StackStartParamsOllamaCacheHost else if value == String "volume" then pure StackStartParamsOllamaCacheVolume else fail "unknown enumeration member"

instance ToJSON StackStartParamsOllamaCache where
  toJSON StackStartParamsOllamaCacheHost = String "host"
  toJSON StackStartParamsOllamaCacheVolume = String "volume"

stackStartParamsOllamaCacheText :: StackStartParamsOllamaCache -> Text
stackStartParamsOllamaCacheText StackStartParamsOllamaCacheHost = "host"
stackStartParamsOllamaCacheText StackStartParamsOllamaCacheVolume = "volume"
