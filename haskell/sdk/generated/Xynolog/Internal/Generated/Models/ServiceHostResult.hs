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
  { serviceHostResultRuntime :: Runtime,
    serviceHostResultAddress :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceHostResult where parseJSON = checked "ServiceHostResult" $ withObject "ServiceHostResult" (\fields -> ServiceHostResult <$> (fields .: "runtime") <*> (fields .: "address"))

instance ToJSON ServiceHostResult where toJSON value = Object (KM.fromList (concat [[("runtime", toJSON (serviceHostResultRuntime value))], [("address", toJSON (serviceHostResultAddress value))]]))
