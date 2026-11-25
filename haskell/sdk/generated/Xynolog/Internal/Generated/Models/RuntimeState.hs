-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RuntimeState (RuntimeState (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Runtime

data RuntimeState = RuntimeState
  { runtimeStateName :: Runtime,
    runtimeStateFound :: Bool
  }
  deriving (Eq, Show)

instance FromJSON RuntimeState where parseJSON = checked "RuntimeState" $ withObject "RuntimeState" (\fields -> RuntimeState <$> (fields .: "name") <*> (fields .: "found"))

instance ToJSON RuntimeState where toJSON value = Object (KM.fromList (concat [[("name", toJSON (runtimeStateName value))], [("found", toJSON (runtimeStateFound value))]]))
