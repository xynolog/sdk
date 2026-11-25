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
    stackStartParamsTarget :: Maybe Target,
    stackStartParamsRuntime :: Maybe Runtime,
    stackStartParamsConfig :: Maybe Text,
    stackStartParamsService :: Maybe Text,
    stackStartParamsGroup :: Maybe ServiceGroup,
    stackStartParamsCodespaceName :: Maybe Text,
    stackStartParamsMachine :: Maybe Text,
    stackStartParamsIdleTimeout :: Maybe Text,
    stackStartParamsRetentionPeriod :: Maybe Text,
    stackStartParamsObserve :: Maybe Bool,
    stackStartParamsOllamaCache :: Maybe StackStartParamsOllamaCache,
    stackStartParamsDryRun :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON StackStartParams where parseJSON = checked "StackStartParams" $ withObject "StackStartParams" (\fields -> StackStartParams <$> (fields .: "apiVersion") <*> optional fields "target" <*> optional fields "runtime" <*> optional fields "config" <*> optional fields "service" <*> optional fields "group" <*> optional fields "codespaceName" <*> optional fields "machine" <*> optional fields "idleTimeout" <*> optional fields "retentionPeriod" <*> optional fields "observe" <*> optional fields "ollamaCache" <*> optional fields "dryRun")

instance ToJSON StackStartParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (stackStartParamsApiVersion value))], optionalPair "target" (stackStartParamsTarget value), optionalPair "runtime" (stackStartParamsRuntime value), optionalPair "config" (stackStartParamsConfig value), optionalPair "service" (stackStartParamsService value), optionalPair "group" (stackStartParamsGroup value), optionalPair "codespaceName" (stackStartParamsCodespaceName value), optionalPair "machine" (stackStartParamsMachine value), optionalPair "idleTimeout" (stackStartParamsIdleTimeout value), optionalPair "retentionPeriod" (stackStartParamsRetentionPeriod value), optionalPair "observe" (stackStartParamsObserve value), optionalPair "ollamaCache" (stackStartParamsOllamaCache value), optionalPair "dryRun" (stackStartParamsDryRun value)]))

data StackStartParamsOllamaCache = StackStartParamsOllamaCacheHost | StackStartParamsOllamaCacheVolume deriving (Eq, Show)

instance FromJSON StackStartParamsOllamaCache where parseJSON = checked "StackStartParamsOllamaCache" $ \value -> if value == String "host" then pure StackStartParamsOllamaCacheHost else if value == String "volume" then pure StackStartParamsOllamaCacheVolume else fail "unknown enumeration member"

instance ToJSON StackStartParamsOllamaCache where
  toJSON StackStartParamsOllamaCacheHost = String "host"
  toJSON StackStartParamsOllamaCacheVolume = String "volume"

stackStartParamsOllamaCacheText :: StackStartParamsOllamaCache -> Text
stackStartParamsOllamaCacheText StackStartParamsOllamaCacheHost = "host"
stackStartParamsOllamaCacheText StackStartParamsOllamaCacheVolume = "volume"
