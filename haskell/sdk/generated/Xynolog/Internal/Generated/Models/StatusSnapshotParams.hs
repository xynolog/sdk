-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StatusSnapshotParams (StatusSnapshotParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.Runtime
import Xynolog.Internal.Generated.Models.Target

data StatusSnapshotParams = StatusSnapshotParams
  { statusSnapshotParamsApiVersion :: ApiVersion,
    statusSnapshotParamsRuntime :: Maybe Runtime,
    statusSnapshotParamsTarget :: Maybe Target
  }
  deriving (Eq, Show)

instance FromJSON StatusSnapshotParams where parseJSON = checked "StatusSnapshotParams" $ withObject "StatusSnapshotParams" (\fields -> StatusSnapshotParams <$> (fields .: "apiVersion") <*> optional fields "runtime" <*> optional fields "target")

instance ToJSON StatusSnapshotParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (statusSnapshotParamsApiVersion value))], optionalPair "runtime" (statusSnapshotParamsRuntime value), optionalPair "target" (statusSnapshotParamsTarget value)]))
