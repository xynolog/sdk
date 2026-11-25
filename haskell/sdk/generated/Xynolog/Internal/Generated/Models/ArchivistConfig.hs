-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistConfig (ArchivistConfig (..), ArchivistConfigStaging (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ArchivistEngines
import Xynolog.Internal.Generated.Models.LogFormat
import Xynolog.Internal.Generated.Models.LogLevel
import Xynolog.Internal.Generated.Models.ServiceIdentity

data ArchivistConfig = ArchivistConfig
  { archivistConfigGatewayUrl :: Text,
    archivistConfigIdentity :: ServiceIdentity,
    archivistConfigRoot :: Text,
    archivistConfigStateHome :: Text,
    archivistConfigAnchoredTextDir :: Text,
    archivistConfigEngines :: ArchivistEngines,
    archivistConfigPort :: Integer,
    archivistConfigSkipRebuild :: Bool,
    archivistConfigStaging :: ArchivistConfigStaging,
    archivistConfigLogLevel :: LogLevel,
    archivistConfigLogFormat :: LogFormat
  }
  deriving (Eq, Show)

instance FromJSON ArchivistConfig where parseJSON = checked "ArchivistConfig" $ withObject "ArchivistConfig" (\fields -> ArchivistConfig <$> (fields .: "gatewayUrl") <*> (fields .: "identity") <*> (fields .: "root") <*> (fields .: "stateHome") <*> (fields .: "anchoredTextDir") <*> (fields .: "engines") <*> (fields .: "port") <*> (fields .: "skipRebuild") <*> (fields .: "staging") <*> (fields .: "logLevel") <*> (fields .: "logFormat"))

instance ToJSON ArchivistConfig where toJSON value = Object (KM.fromList (concat [[("gatewayUrl", toJSON (archivistConfigGatewayUrl value))], [("identity", toJSON (archivistConfigIdentity value))], [("root", toJSON (archivistConfigRoot value))], [("stateHome", toJSON (archivistConfigStateHome value))], [("anchoredTextDir", toJSON (archivistConfigAnchoredTextDir value))], [("engines", toJSON (archivistConfigEngines value))], [("port", toJSON (archivistConfigPort value))], [("skipRebuild", toJSON (archivistConfigSkipRebuild value))], [("staging", toJSON (archivistConfigStaging value))], [("logLevel", toJSON (archivistConfigLogLevel value))], [("logFormat", toJSON (archivistConfigLogFormat value))]]))

data ArchivistConfigStaging = ArchivistConfigStaging
  { archivistConfigStagingFlushMs :: Integer,
    archivistConfigStagingMaxWaitMs :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ArchivistConfigStaging where parseJSON = checked "ArchivistConfigStaging" $ withObject "ArchivistConfigStaging" (\fields -> ArchivistConfigStaging <$> (fields .: "flushMs") <*> (fields .: "maxWaitMs"))

instance ToJSON ArchivistConfigStaging where toJSON value = Object (KM.fromList (concat [[("flushMs", toJSON (archivistConfigStagingFlushMs value))], [("maxWaitMs", toJSON (archivistConfigStagingMaxWaitMs value))]]))
