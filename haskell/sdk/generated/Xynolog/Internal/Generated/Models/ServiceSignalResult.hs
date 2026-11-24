-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceSignalResult (ServiceSignalResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data ServiceSignalResult = ServiceSignalResult
  { serviceSignalResultDelivered :: Bool
  }
  deriving (Eq, Show)

instance FromJSON ServiceSignalResult where parseJSON = checked "ServiceSignalResult" $ withObject "ServiceSignalResult" (\fields -> ServiceSignalResult <$> (fields .: "delivered"))

instance ToJSON ServiceSignalResult where toJSON value = Object (KM.fromList (concat [[("delivered", toJSON (serviceSignalResultDelivered value))]]))
