-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceRunResult (ServiceRunResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.RunInstance

data ServiceRunResult = ServiceRunResult
  { serviceRunResultExitCode :: Integer,
    serviceRunResultInstance :: RunInstance,
    serviceRunResultRanMs :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ServiceRunResult where parseJSON = checked "ServiceRunResult" $ withObject "ServiceRunResult" (\fields -> ServiceRunResult <$> (fields .: "exitCode") <*> (fields .: "instance") <*> (fields .: "ranMs"))

instance ToJSON ServiceRunResult where toJSON value = Object (KM.fromList (concat [[("exitCode", toJSON (serviceRunResultExitCode value))], [("instance", toJSON (serviceRunResultInstance value))], [("ranMs", toJSON (serviceRunResultRanMs value))]]))
