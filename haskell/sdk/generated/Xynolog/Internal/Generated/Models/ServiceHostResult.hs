-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceHostResult (ServiceHostResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Runtime

data ServiceHostResult = ServiceHostResult
  { serviceHostResultAddress :: Text,
    serviceHostResultRuntime :: Runtime
  }
  deriving (Eq, Show)

instance FromJSON ServiceHostResult where parseJSON = checked "ServiceHostResult" $ withObject "ServiceHostResult" (\fields -> ServiceHostResult <$> (fields .: "address") <*> (fields .: "runtime"))

instance ToJSON ServiceHostResult where toJSON value = Object (KM.fromList (concat [[("address", toJSON (serviceHostResultAddress value))], [("runtime", toJSON (serviceHostResultRuntime value))]]))
