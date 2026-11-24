-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceOutput (ServiceOutput (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.OutputStream
import Xynolog.Internal.Generated.Models.RequestId
import Xynolog.Internal.Generated.Models.RunInstance

data ServiceOutput = ServiceOutput
  { serviceOutputInstance :: RunInstance,
    serviceOutputLine :: Text,
    serviceOutputRequestId :: RequestId,
    serviceOutputStream :: OutputStream
  }
  deriving (Eq, Show)

instance FromJSON ServiceOutput where parseJSON = checked "ServiceOutput" $ withObject "ServiceOutput" (\fields -> ServiceOutput <$> (fields .: "instance") <*> (fields .: "line") <*> (fields .: "requestId") <*> (fields .: "stream"))

instance ToJSON ServiceOutput where toJSON value = Object (KM.fromList (concat [[("instance", toJSON (serviceOutputInstance value))], [("line", toJSON (serviceOutputLine value))], [("requestId", toJSON (serviceOutputRequestId value))], [("stream", toJSON (serviceOutputStream value))]]))
