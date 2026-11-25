-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SmelterConfig (SmelterConfig (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.CursorsPath
import Xynolog.Internal.Generated.Models.EmbeddingConfig
import Xynolog.Internal.Generated.Models.KbIdentity
import Xynolog.Internal.Generated.Models.LogFormat
import Xynolog.Internal.Generated.Models.LogLevel
import Xynolog.Internal.Generated.Models.ServiceAddress
import Xynolog.Internal.Generated.Models.ServiceIdentity
import Xynolog.Internal.Generated.Models.SmelterChunking
import Xynolog.Internal.Generated.Models.VectorsConfig

data SmelterConfig = SmelterConfig
  { smelterConfigKb :: KbIdentity,
    smelterConfigGatewayUrl :: Text,
    smelterConfigIdentity :: ServiceIdentity,
    smelterConfigArchivist :: ServiceAddress,
    smelterConfigEmbedding :: EmbeddingConfig,
    smelterConfigVectors :: VectorsConfig,
    smelterConfigChunking :: SmelterChunking,
    smelterConfigPdfsAtOnce :: Integer,
    smelterConfigCursorsPath :: CursorsPath,
    smelterConfigPort :: Integer,
    smelterConfigLogLevel :: LogLevel,
    smelterConfigLogFormat :: LogFormat
  }
  deriving (Eq, Show)

instance FromJSON SmelterConfig where parseJSON = checked "SmelterConfig" $ withObject "SmelterConfig" (\fields -> SmelterConfig <$> (fields .: "kb") <*> (fields .: "gatewayUrl") <*> (fields .: "identity") <*> (fields .: "archivist") <*> (fields .: "embedding") <*> (fields .: "vectors") <*> (fields .: "chunking") <*> (fields .: "pdfsAtOnce") <*> (fields .: "cursorsPath") <*> (fields .: "port") <*> (fields .: "logLevel") <*> (fields .: "logFormat"))

instance ToJSON SmelterConfig where toJSON value = Object (KM.fromList (concat [[("kb", toJSON (smelterConfigKb value))], [("gatewayUrl", toJSON (smelterConfigGatewayUrl value))], [("identity", toJSON (smelterConfigIdentity value))], [("archivist", toJSON (smelterConfigArchivist value))], [("embedding", toJSON (smelterConfigEmbedding value))], [("vectors", toJSON (smelterConfigVectors value))], [("chunking", toJSON (smelterConfigChunking value))], [("pdfsAtOnce", toJSON (smelterConfigPdfsAtOnce value))], [("cursorsPath", toJSON (smelterConfigCursorsPath value))], [("port", toJSON (smelterConfigPort value))], [("logLevel", toJSON (smelterConfigLogLevel value))], [("logFormat", toJSON (smelterConfigLogFormat value))]]))
