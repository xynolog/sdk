-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceGroup (ServiceGroup (..), serviceGroupText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data ServiceGroup = ServiceGroupRecord | ServiceGroupIndex | ServiceGroupIssuer | ServiceGroupKnowledgeWorkers | ServiceGroupProviders | ServiceGroupTelemetry deriving (Eq, Show)

instance FromJSON ServiceGroup where parseJSON = checked "ServiceGroup" $ \value -> if value == String "record" then pure ServiceGroupRecord else if value == String "index" then pure ServiceGroupIndex else if value == String "issuer" then pure ServiceGroupIssuer else if value == String "knowledge-workers" then pure ServiceGroupKnowledgeWorkers else if value == String "providers" then pure ServiceGroupProviders else if value == String "telemetry" then pure ServiceGroupTelemetry else fail "unknown enumeration member"

instance ToJSON ServiceGroup where
  toJSON ServiceGroupRecord = String "record"
  toJSON ServiceGroupIndex = String "index"
  toJSON ServiceGroupIssuer = String "issuer"
  toJSON ServiceGroupKnowledgeWorkers = String "knowledge-workers"
  toJSON ServiceGroupProviders = String "providers"
  toJSON ServiceGroupTelemetry = String "telemetry"

serviceGroupText :: ServiceGroup -> Text
serviceGroupText ServiceGroupRecord = "record"
serviceGroupText ServiceGroupIndex = "index"
serviceGroupText ServiceGroupIssuer = "issuer"
serviceGroupText ServiceGroupKnowledgeWorkers = "knowledge-workers"
serviceGroupText ServiceGroupProviders = "providers"
serviceGroupText ServiceGroupTelemetry = "telemetry"
