-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceImplementations (ConformanceImplementations (..), ConformanceImplementationsSdks (..), ConformanceImplementationsSdksValue (..), ConformanceImplementationsSdksValueExempt (..), ConformanceImplementationsSdksValueLive (..), ConformanceImplementationsSdksValueLiveTier (..), conformanceImplementationsSdksValueLiveTierText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.LocalTarget

data ConformanceImplementations = ConformanceImplementations
  { conformanceImplementationsLauncher :: [Text],
    conformanceImplementationsTarget :: LocalTarget,
    conformanceImplementationsSdks :: ConformanceImplementationsSdks,
    conformanceImplementationsModelCatalogue :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementations where parseJSON = checked "ConformanceImplementations" $ withObject "ConformanceImplementations" (\fields -> ConformanceImplementations <$> (fields .: "launcher") <*> (fields .: "target") <*> (fields .: "sdks") <*> optional fields "modelCatalogue")

instance ToJSON ConformanceImplementations where toJSON value = Object (KM.fromList (concat [[("launcher", toJSON (conformanceImplementationsLauncher value))], [("target", toJSON (conformanceImplementationsTarget value))], [("sdks", toJSON (conformanceImplementationsSdks value))], optionalPair "modelCatalogue" (conformanceImplementationsModelCatalogue value)]))

data ConformanceImplementationsSdks = ConformanceImplementationsSdks
  { conformanceImplementationsSdksAdditionalProperties :: KM.KeyMap ConformanceImplementationsSdksValue
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdks where parseJSON = checked "ConformanceImplementationsSdks" $ withObject "ConformanceImplementationsSdks" (\fields -> ConformanceImplementationsSdks <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceImplementationsSdks where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceImplementationsSdksAdditionalProperties value)))

data ConformanceImplementationsSdksValue = ConformanceImplementationsSdksValue
  { conformanceImplementationsSdksValueWire :: Maybe [Text],
    conformanceImplementationsSdksValueLive :: Maybe ConformanceImplementationsSdksValueLive,
    conformanceImplementationsSdksValueWorker :: Maybe [Text],
    conformanceImplementationsSdksValueExempt :: Maybe ConformanceImplementationsSdksValueExempt
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdksValue where parseJSON = checked "ConformanceImplementationsSdksValue" $ withObject "ConformanceImplementationsSdksValue" (\fields -> ConformanceImplementationsSdksValue <$> optional fields "wire" <*> optional fields "live" <*> optional fields "worker" <*> optional fields "exempt")

instance ToJSON ConformanceImplementationsSdksValue where toJSON value = Object (KM.fromList (concat [optionalPair "wire" (conformanceImplementationsSdksValueWire value), optionalPair "live" (conformanceImplementationsSdksValueLive value), optionalPair "worker" (conformanceImplementationsSdksValueWorker value), optionalPair "exempt" (conformanceImplementationsSdksValueExempt value)]))

data ConformanceImplementationsSdksValueExempt = ConformanceImplementationsSdksValueExempt
  { conformanceImplementationsSdksValueExemptAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdksValueExempt where parseJSON = checked "ConformanceImplementationsSdksValueExempt" $ withObject "ConformanceImplementationsSdksValueExempt" (\fields -> ConformanceImplementationsSdksValueExempt <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceImplementationsSdksValueExempt where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceImplementationsSdksValueExemptAdditionalProperties value)))

data ConformanceImplementationsSdksValueLive = ConformanceImplementationsSdksValueLive
  { conformanceImplementationsSdksValueLiveCommand :: [Text],
    conformanceImplementationsSdksValueLiveTier :: ConformanceImplementationsSdksValueLiveTier
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdksValueLive where parseJSON = checked "ConformanceImplementationsSdksValueLive" $ withObject "ConformanceImplementationsSdksValueLive" (\fields -> ConformanceImplementationsSdksValueLive <$> (fields .: "command") <*> (fields .: "tier"))

instance ToJSON ConformanceImplementationsSdksValueLive where toJSON value = Object (KM.fromList (concat [[("command", toJSON (conformanceImplementationsSdksValueLiveCommand value))], [("tier", toJSON (conformanceImplementationsSdksValueLiveTier value))]]))

data ConformanceImplementationsSdksValueLiveTier = ConformanceImplementationsSdksValueLiveTierFleet | ConformanceImplementationsSdksValueLiveTierParity deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdksValueLiveTier where parseJSON = checked "ConformanceImplementationsSdksValueLiveTier" $ \value -> if value == String "fleet" then pure ConformanceImplementationsSdksValueLiveTierFleet else if value == String "parity" then pure ConformanceImplementationsSdksValueLiveTierParity else fail "unknown enumeration member"

instance ToJSON ConformanceImplementationsSdksValueLiveTier where
  toJSON ConformanceImplementationsSdksValueLiveTierFleet = String "fleet"
  toJSON ConformanceImplementationsSdksValueLiveTierParity = String "parity"

conformanceImplementationsSdksValueLiveTierText :: ConformanceImplementationsSdksValueLiveTier -> Text
conformanceImplementationsSdksValueLiveTierText ConformanceImplementationsSdksValueLiveTierFleet = "fleet"
conformanceImplementationsSdksValueLiveTierText ConformanceImplementationsSdksValueLiveTierParity = "parity"
