-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceImplementations (ConformanceImplementations (..), ConformanceImplementationsSdks (..), ConformanceImplementationsSdksAdditionalValue (..), ConformanceImplementationsSdksAdditionalValueExempt (..), ConformanceImplementationsSdksAdditionalValueLive (..), ConformanceImplementationsSdksAdditionalValueLiveTier (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.LocalTarget

data ConformanceImplementations = ConformanceImplementations
  { conformanceImplementationsLauncher :: [Text],
    conformanceImplementationsModelCatalogue :: Maybe Text,
    conformanceImplementationsSdks :: ConformanceImplementationsSdks,
    conformanceImplementationsTarget :: LocalTarget
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementations where parseJSON = checked "ConformanceImplementations" $ withObject "ConformanceImplementations" (\fields -> ConformanceImplementations <$> (fields .: "launcher") <*> optional fields "modelCatalogue" <*> (fields .: "sdks") <*> (fields .: "target"))

instance ToJSON ConformanceImplementations where toJSON value = Object (KM.fromList (concat [[("launcher", toJSON (conformanceImplementationsLauncher value))], optionalPair "modelCatalogue" (conformanceImplementationsModelCatalogue value), [("sdks", toJSON (conformanceImplementationsSdks value))], [("target", toJSON (conformanceImplementationsTarget value))]]))

data ConformanceImplementationsSdks = ConformanceImplementationsSdks
  { conformanceImplementationsSdksAdditionalProperties :: KM.KeyMap ConformanceImplementationsSdksAdditionalValue
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdks where parseJSON = checked "ConformanceImplementationsSdks" $ withObject "ConformanceImplementationsSdks" (\fields -> ConformanceImplementationsSdks <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceImplementationsSdks where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceImplementationsSdksAdditionalProperties value)))

data ConformanceImplementationsSdksAdditionalValue = ConformanceImplementationsSdksAdditionalValue
  { conformanceImplementationsSdksAdditionalValueExempt :: Maybe ConformanceImplementationsSdksAdditionalValueExempt,
    conformanceImplementationsSdksAdditionalValueLive :: Maybe ConformanceImplementationsSdksAdditionalValueLive,
    conformanceImplementationsSdksAdditionalValueWire :: Maybe [Text],
    conformanceImplementationsSdksAdditionalValueWorker :: Maybe [Text]
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdksAdditionalValue where parseJSON = checked "ConformanceImplementationsSdksAdditionalValue" $ withObject "ConformanceImplementationsSdksAdditionalValue" (\fields -> ConformanceImplementationsSdksAdditionalValue <$> optional fields "exempt" <*> optional fields "live" <*> optional fields "wire" <*> optional fields "worker")

instance ToJSON ConformanceImplementationsSdksAdditionalValue where toJSON value = Object (KM.fromList (concat [optionalPair "exempt" (conformanceImplementationsSdksAdditionalValueExempt value), optionalPair "live" (conformanceImplementationsSdksAdditionalValueLive value), optionalPair "wire" (conformanceImplementationsSdksAdditionalValueWire value), optionalPair "worker" (conformanceImplementationsSdksAdditionalValueWorker value)]))

data ConformanceImplementationsSdksAdditionalValueExempt = ConformanceImplementationsSdksAdditionalValueExempt
  { conformanceImplementationsSdksAdditionalValueExemptAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdksAdditionalValueExempt where parseJSON = checked "ConformanceImplementationsSdksAdditionalValueExempt" $ withObject "ConformanceImplementationsSdksAdditionalValueExempt" (\fields -> ConformanceImplementationsSdksAdditionalValueExempt <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceImplementationsSdksAdditionalValueExempt where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceImplementationsSdksAdditionalValueExemptAdditionalProperties value)))

data ConformanceImplementationsSdksAdditionalValueLive = ConformanceImplementationsSdksAdditionalValueLive
  { conformanceImplementationsSdksAdditionalValueLiveCommand :: [Text],
    conformanceImplementationsSdksAdditionalValueLiveTier :: ConformanceImplementationsSdksAdditionalValueLiveTier
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdksAdditionalValueLive where parseJSON = checked "ConformanceImplementationsSdksAdditionalValueLive" $ withObject "ConformanceImplementationsSdksAdditionalValueLive" (\fields -> ConformanceImplementationsSdksAdditionalValueLive <$> (fields .: "command") <*> (fields .: "tier"))

instance ToJSON ConformanceImplementationsSdksAdditionalValueLive where toJSON value = Object (KM.fromList (concat [[("command", toJSON (conformanceImplementationsSdksAdditionalValueLiveCommand value))], [("tier", toJSON (conformanceImplementationsSdksAdditionalValueLiveTier value))]]))

data ConformanceImplementationsSdksAdditionalValueLiveTier = ConformanceImplementationsSdksAdditionalValueLiveTierFleet | ConformanceImplementationsSdksAdditionalValueLiveTierParity deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdksAdditionalValueLiveTier where parseJSON = checked "ConformanceImplementationsSdksAdditionalValueLiveTier" $ \value -> if value == String "fleet" then pure ConformanceImplementationsSdksAdditionalValueLiveTierFleet else if value == String "parity" then pure ConformanceImplementationsSdksAdditionalValueLiveTierParity else fail "unknown enumeration member"

instance ToJSON ConformanceImplementationsSdksAdditionalValueLiveTier where
  toJSON ConformanceImplementationsSdksAdditionalValueLiveTierFleet = String "fleet"
  toJSON ConformanceImplementationsSdksAdditionalValueLiveTierParity = String "parity"
