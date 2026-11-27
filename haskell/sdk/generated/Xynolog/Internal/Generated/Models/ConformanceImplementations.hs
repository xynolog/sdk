-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceImplementations (ConformanceImplementations (..), ConformanceImplementationsSdksValue (..), ConformanceImplementationsSdksValueLive (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceCase
import Xynolog.Internal.Generated.Models.LocalTarget

data ConformanceImplementations = ConformanceImplementations
  { conformanceImplementationsLauncher :: [Text],
    conformanceImplementationsTarget :: LocalTarget,
    conformanceImplementationsSdks :: KM.KeyMap ConformanceImplementationsSdksValue,
    conformanceImplementationsModelCatalogue :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementations where parseJSON = checked "ConformanceImplementations" $ withObject "ConformanceImplementations" (\fields -> ConformanceImplementations <$> (fields .: "launcher") <*> (fields .: "target") <*> (fields .: "sdks") <*> optional fields "modelCatalogue")

instance ToJSON ConformanceImplementations where toJSON value = Object (KM.fromList (concat [[("launcher", toJSON (conformanceImplementationsLauncher value))], [("target", toJSON (conformanceImplementationsTarget value))], [("sdks", toJSON (conformanceImplementationsSdks value))], optionalPair "modelCatalogue" (conformanceImplementationsModelCatalogue value)]))

data ConformanceImplementationsSdksValue = ConformanceImplementationsSdksValue
  { conformanceImplementationsSdksValueWire :: Maybe [Text],
    conformanceImplementationsSdksValueLive :: Maybe ConformanceImplementationsSdksValueLive,
    conformanceImplementationsSdksValueWorker :: Maybe [Text],
    conformanceImplementationsSdksValueExempt :: Maybe (KM.KeyMap Text)
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdksValue where parseJSON = checked "ConformanceImplementationsSdksValue" $ withObject "ConformanceImplementationsSdksValue" (\fields -> ConformanceImplementationsSdksValue <$> optional fields "wire" <*> optional fields "live" <*> optional fields "worker" <*> optional fields "exempt")

instance ToJSON ConformanceImplementationsSdksValue where toJSON value = Object (KM.fromList (concat [optionalPair "wire" (conformanceImplementationsSdksValueWire value), optionalPair "live" (conformanceImplementationsSdksValueLive value), optionalPair "worker" (conformanceImplementationsSdksValueWorker value), optionalPair "exempt" (conformanceImplementationsSdksValueExempt value)]))

data ConformanceImplementationsSdksValueLive = ConformanceImplementationsSdksValueLive
  { conformanceImplementationsSdksValueLiveCommand :: [Text],
    conformanceImplementationsSdksValueLiveTier :: ConformanceCaseTier
  }
  deriving (Eq, Show)

instance FromJSON ConformanceImplementationsSdksValueLive where parseJSON = checked "ConformanceImplementationsSdksValueLive" $ withObject "ConformanceImplementationsSdksValueLive" (\fields -> ConformanceImplementationsSdksValueLive <$> (fields .: "command") <*> (fields .: "tier"))

instance ToJSON ConformanceImplementationsSdksValueLive where toJSON value = Object (KM.fromList (concat [[("command", toJSON (conformanceImplementationsSdksValueLiveCommand value))], [("tier", toJSON (conformanceImplementationsSdksValueLiveTier value))]]))
