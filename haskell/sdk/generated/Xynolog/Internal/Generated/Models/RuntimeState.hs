-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RuntimeState (RuntimeState (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Runtime

data RuntimeState = RuntimeState
  { runtimeStateFound :: Bool,
    runtimeStateName :: Runtime
  }
  deriving (Eq, Show)

instance FromJSON RuntimeState where parseJSON = checked "RuntimeState" $ withObject "RuntimeState" (\fields -> RuntimeState <$> (fields .: "found") <*> (fields .: "name"))

instance ToJSON RuntimeState where toJSON value = Object (KM.fromList (concat [[("found", toJSON (runtimeStateFound value))], [("name", toJSON (runtimeStateName value))]]))
