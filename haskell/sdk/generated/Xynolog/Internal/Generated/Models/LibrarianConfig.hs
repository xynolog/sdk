-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LibrarianConfig (LibrarianConfig (..), LibrarianConfigGather (..), LibrarianConfigSearch (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.EmbeddingConfig
import Xynolog.Internal.Generated.Models.GraphConfig
import Xynolog.Internal.Generated.Models.KbIdentity
import Xynolog.Internal.Generated.Models.LibrarianEngineConfig
import Xynolog.Internal.Generated.Models.LogFormat
import Xynolog.Internal.Generated.Models.LogLevel
import Xynolog.Internal.Generated.Models.ServiceAddress
import Xynolog.Internal.Generated.Models.ServiceIdentity
import Xynolog.Internal.Generated.Models.VectorsConfig

data LibrarianConfig = LibrarianConfig
  { librarianConfigKb :: KbIdentity,
    librarianConfigGatewayUrl :: Text,
    librarianConfigIdentity :: ServiceIdentity,
    librarianConfigArchivist :: ServiceAddress,
    librarianConfigGraph :: GraphConfig,
    librarianConfigVectors :: VectorsConfig,
    librarianConfigEmbedding :: EmbeddingConfig,
    librarianConfigMatcher :: LibrarianEngineConfig,
    librarianConfigGatherer :: LibrarianEngineConfig,
    librarianConfigModelCatalogue :: Text,
    librarianConfigGather :: LibrarianConfigGather,
    librarianConfigSearch :: LibrarianConfigSearch,
    librarianConfigPort :: Integer,
    librarianConfigLogLevel :: LogLevel,
    librarianConfigLogFormat :: LogFormat
  }
  deriving (Eq, Show)

instance FromJSON LibrarianConfig where parseJSON = checked "LibrarianConfig" $ withObject "LibrarianConfig" (\fields -> LibrarianConfig <$> (fields .: "kb") <*> (fields .: "gatewayUrl") <*> (fields .: "identity") <*> (fields .: "archivist") <*> (fields .: "graph") <*> (fields .: "vectors") <*> (fields .: "embedding") <*> (fields .: "matcher") <*> (fields .: "gatherer") <*> (fields .: "modelCatalogue") <*> (fields .: "gather") <*> (fields .: "search") <*> (fields .: "port") <*> (fields .: "logLevel") <*> (fields .: "logFormat"))

instance ToJSON LibrarianConfig where toJSON value = Object (KM.fromList (concat [[("kb", toJSON (librarianConfigKb value))], [("gatewayUrl", toJSON (librarianConfigGatewayUrl value))], [("identity", toJSON (librarianConfigIdentity value))], [("archivist", toJSON (librarianConfigArchivist value))], [("graph", toJSON (librarianConfigGraph value))], [("vectors", toJSON (librarianConfigVectors value))], [("embedding", toJSON (librarianConfigEmbedding value))], [("matcher", toJSON (librarianConfigMatcher value))], [("gatherer", toJSON (librarianConfigGatherer value))], [("modelCatalogue", toJSON (librarianConfigModelCatalogue value))], [("gather", toJSON (librarianConfigGather value))], [("search", toJSON (librarianConfigSearch value))], [("port", toJSON (librarianConfigPort value))], [("logLevel", toJSON (librarianConfigLogLevel value))], [("logFormat", toJSON (librarianConfigLogFormat value))]]))

data LibrarianConfigGather = LibrarianConfigGather
  { librarianConfigGatherSettleTimeoutMs :: Integer
  }
  deriving (Eq, Show)

instance FromJSON LibrarianConfigGather where parseJSON = checked "LibrarianConfigGather" $ withObject "LibrarianConfigGather" (\fields -> LibrarianConfigGather <$> (fields .: "settleTimeoutMs"))

instance ToJSON LibrarianConfigGather where toJSON value = Object (KM.fromList (concat [[("settleTimeoutMs", toJSON (librarianConfigGatherSettleTimeoutMs value))]]))

data LibrarianConfigSearch = LibrarianConfigSearch
  { librarianConfigSearchSemanticFloor :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON LibrarianConfigSearch where parseJSON = checked "LibrarianConfigSearch" $ withObject "LibrarianConfigSearch" (\fields -> LibrarianConfigSearch <$> (fields .: "semanticFloor"))

instance ToJSON LibrarianConfigSearch where toJSON value = Object (KM.fromList (concat [[("semanticFloor", toJSON (librarianConfigSearchSemanticFloor value))]]))
