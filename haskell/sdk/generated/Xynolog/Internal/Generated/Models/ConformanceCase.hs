-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceCase (ConformanceCase (..), ConformanceCasePlanesItem (..), ConformanceCaseTelemetry (..), ConformanceCaseTier (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceStep

data ConformanceCase = ConformanceCase
  { conformanceCaseAbout :: Text,
    conformanceCasePlanes :: Maybe [ConformanceCasePlanesItem],
    conformanceCaseSource :: Text,
    conformanceCaseSteps :: [ConformanceStep],
    conformanceCaseTelemetry :: Maybe ConformanceCaseTelemetry,
    conformanceCaseTier :: Maybe ConformanceCaseTier
  }
  deriving (Eq, Show)

instance FromJSON ConformanceCase where parseJSON = checked "ConformanceCase" $ withObject "ConformanceCase" (\fields -> ConformanceCase <$> (fields .: "about") <*> optional fields "planes" <*> (fields .: "source") <*> (fields .: "steps") <*> optional fields "telemetry" <*> optional fields "tier")

instance ToJSON ConformanceCase where toJSON value = Object (KM.fromList (concat [[("about", toJSON (conformanceCaseAbout value))], optionalPair "planes" (conformanceCasePlanes value), [("source", toJSON (conformanceCaseSource value))], [("steps", toJSON (conformanceCaseSteps value))], optionalPair "telemetry" (conformanceCaseTelemetry value), optionalPair "tier" (conformanceCaseTier value)]))

data ConformanceCasePlanesItem = ConformanceCasePlanesItemInU2d_process | ConformanceCasePlanesItemNats deriving (Eq, Show)

instance FromJSON ConformanceCasePlanesItem where parseJSON = checked "ConformanceCasePlanesItem" $ \value -> if value == String "in-process" then pure ConformanceCasePlanesItemInU2d_process else if value == String "nats" then pure ConformanceCasePlanesItemNats else fail "unknown enumeration member"

instance ToJSON ConformanceCasePlanesItem where
  toJSON ConformanceCasePlanesItemInU2d_process = String "in-process"
  toJSON ConformanceCasePlanesItemNats = String "nats"

data ConformanceCaseTelemetry = ConformanceCaseTelemetryTrue deriving (Eq, Show)

instance FromJSON ConformanceCaseTelemetry where parseJSON = checked "ConformanceCaseTelemetry" $ \value -> if value == Bool True then pure ConformanceCaseTelemetryTrue else fail "unknown enumeration member"

instance ToJSON ConformanceCaseTelemetry where toJSON ConformanceCaseTelemetryTrue = Bool True

data ConformanceCaseTier = ConformanceCaseTierFleet | ConformanceCaseTierParity deriving (Eq, Show)

instance FromJSON ConformanceCaseTier where parseJSON = checked "ConformanceCaseTier" $ \value -> if value == String "fleet" then pure ConformanceCaseTierFleet else if value == String "parity" then pure ConformanceCaseTierParity else fail "unknown enumeration member"

instance ToJSON ConformanceCaseTier where
  toJSON ConformanceCaseTierFleet = String "fleet"
  toJSON ConformanceCaseTierParity = String "parity"
