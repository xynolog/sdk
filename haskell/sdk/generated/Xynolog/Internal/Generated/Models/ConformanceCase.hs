-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceCase (ConformanceCase (..), ConformanceCaseTelemetry (..), ConformanceCaseTier (..), conformanceCaseTierText, GatewayConfigSignalType (..), gatewayConfigSignalTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceStep

data ConformanceCase = ConformanceCase
  { conformanceCaseAbout :: Text,
    conformanceCaseSource :: Text,
    conformanceCasePlanes :: Maybe [GatewayConfigSignalType],
    conformanceCaseTier :: Maybe ConformanceCaseTier,
    conformanceCaseTelemetry :: Maybe ConformanceCaseTelemetry,
    conformanceCaseSteps :: [ConformanceStep]
  }
  deriving (Eq, Show)

instance FromJSON ConformanceCase where parseJSON = checked "ConformanceCase" $ withObject "ConformanceCase" (\fields -> ConformanceCase <$> (fields .: "about") <*> (fields .: "source") <*> optional fields "planes" <*> optional fields "tier" <*> optional fields "telemetry" <*> (fields .: "steps"))

instance ToJSON ConformanceCase where toJSON value = Object (KM.fromList (concat [[("about", toJSON (conformanceCaseAbout value))], [("source", toJSON (conformanceCaseSource value))], optionalPair "planes" (conformanceCasePlanes value), optionalPair "tier" (conformanceCaseTier value), optionalPair "telemetry" (conformanceCaseTelemetry value), [("steps", toJSON (conformanceCaseSteps value))]]))

data ConformanceCaseTelemetry = ConformanceCaseTelemetryTrue deriving (Eq, Show)

instance FromJSON ConformanceCaseTelemetry where parseJSON = checked "ConformanceCaseTelemetry" $ \value -> if value == Bool True then pure ConformanceCaseTelemetryTrue else fail "unknown enumeration member"

instance ToJSON ConformanceCaseTelemetry where toJSON ConformanceCaseTelemetryTrue = Bool True

data ConformanceCaseTier = ConformanceCaseTierFleet | ConformanceCaseTierParity deriving (Eq, Show)

instance FromJSON ConformanceCaseTier where parseJSON = checked "ConformanceCaseTier" $ \value -> if value == String "fleet" then pure ConformanceCaseTierFleet else if value == String "parity" then pure ConformanceCaseTierParity else fail "unknown enumeration member"

instance ToJSON ConformanceCaseTier where
  toJSON ConformanceCaseTierFleet = String "fleet"
  toJSON ConformanceCaseTierParity = String "parity"

conformanceCaseTierText :: ConformanceCaseTier -> Text
conformanceCaseTierText ConformanceCaseTierFleet = "fleet"
conformanceCaseTierText ConformanceCaseTierParity = "parity"

data GatewayConfigSignalType = GatewayConfigSignalTypeInProcess | GatewayConfigSignalTypeNats deriving (Eq, Show)

instance FromJSON GatewayConfigSignalType where parseJSON = checked "GatewayConfigSignalType" $ \value -> if value == String "in-process" then pure GatewayConfigSignalTypeInProcess else if value == String "nats" then pure GatewayConfigSignalTypeNats else fail "unknown enumeration member"

instance ToJSON GatewayConfigSignalType where
  toJSON GatewayConfigSignalTypeInProcess = String "in-process"
  toJSON GatewayConfigSignalTypeNats = String "nats"

gatewayConfigSignalTypeText :: GatewayConfigSignalType -> Text
gatewayConfigSignalTypeText GatewayConfigSignalTypeInProcess = "in-process"
gatewayConfigSignalTypeText GatewayConfigSignalTypeNats = "nats"
