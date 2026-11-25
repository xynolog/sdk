-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WeaverConfig (WeaverConfig (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.CursorsPath
import Xynolog.Internal.Generated.Models.GraphConfig
import Xynolog.Internal.Generated.Models.KbIdentity
import Xynolog.Internal.Generated.Models.LogFormat
import Xynolog.Internal.Generated.Models.LogLevel
import Xynolog.Internal.Generated.Models.ServiceAddress
import Xynolog.Internal.Generated.Models.ServiceIdentity

data WeaverConfig = WeaverConfig
  { weaverConfigKb :: KbIdentity,
    weaverConfigGatewayUrl :: Text,
    weaverConfigIdentity :: ServiceIdentity,
    weaverConfigArchivist :: ServiceAddress,
    weaverConfigGraph :: GraphConfig,
    weaverConfigCursorsPath :: CursorsPath,
    weaverConfigPort :: Integer,
    weaverConfigLogLevel :: LogLevel,
    weaverConfigLogFormat :: LogFormat
  }
  deriving (Eq, Show)

instance FromJSON WeaverConfig where parseJSON = checked "WeaverConfig" $ withObject "WeaverConfig" (\fields -> WeaverConfig <$> (fields .: "kb") <*> (fields .: "gatewayUrl") <*> (fields .: "identity") <*> (fields .: "archivist") <*> (fields .: "graph") <*> (fields .: "cursorsPath") <*> (fields .: "port") <*> (fields .: "logLevel") <*> (fields .: "logFormat"))

instance ToJSON WeaverConfig where toJSON value = Object (KM.fromList (concat [[("kb", toJSON (weaverConfigKb value))], [("gatewayUrl", toJSON (weaverConfigGatewayUrl value))], [("identity", toJSON (weaverConfigIdentity value))], [("archivist", toJSON (weaverConfigArchivist value))], [("graph", toJSON (weaverConfigGraph value))], [("cursorsPath", toJSON (weaverConfigCursorsPath value))], [("port", toJSON (weaverConfigPort value))], [("logLevel", toJSON (weaverConfigLogLevel value))], [("logFormat", toJSON (weaverConfigLogFormat value))]]))
