-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KnowledgeIndex (KnowledgeIndex (..), KnowledgeIndexKind (..), KnowledgeIndexSpec (..), KnowledgeIndexSpecEmbedding (..), KnowledgeIndexSpecEmbeddingChunking (..), KnowledgeIndexSpecLibrarian (..), KnowledgeIndexSpecLibrarianGather (..), KnowledgeIndexSpecLibrarianSearch (..), KnowledgeIndexSpecSmelter (..), KnowledgeIndexSpecVectors (..), KnowledgeIndexSpecVectorsExternal (..), KnowledgeIndexSpecVectorsShared (..), KnowledgeIndexSpecWeaver (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Image
import Xynolog.Internal.Generated.Models.LogLevel
import Xynolog.Internal.Generated.Models.Metadata
import Xynolog.Internal.Generated.Models.Resources
import Xynolog.Internal.Generated.Models.Runner
import Xynolog.Internal.Generated.Models.SecretRef
import Xynolog.Internal.Generated.Models.StackApiVersion

data KnowledgeIndex = KnowledgeIndex
  { knowledgeIndexApiVersion :: StackApiVersion,
    knowledgeIndexKind :: KnowledgeIndexKind,
    knowledgeIndexMetadata :: Metadata,
    knowledgeIndexSpec :: KnowledgeIndexSpec
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndex where parseJSON = checked "KnowledgeIndex" $ withObject "KnowledgeIndex" (\fields -> KnowledgeIndex <$> (fields .: "apiVersion") <*> (fields .: "kind") <*> (fields .: "metadata") <*> (fields .: "spec"))

instance ToJSON KnowledgeIndex where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (knowledgeIndexApiVersion value))], [("kind", toJSON (knowledgeIndexKind value))], [("metadata", toJSON (knowledgeIndexMetadata value))], [("spec", toJSON (knowledgeIndexSpec value))]]))

data KnowledgeIndexKind = KnowledgeIndexKindKnowledgeIndex deriving (Eq, Show)

instance FromJSON KnowledgeIndexKind where parseJSON = checked "KnowledgeIndexKind" $ \value -> if value == String "KnowledgeIndex" then pure KnowledgeIndexKindKnowledgeIndex else fail "unknown enumeration member"

instance ToJSON KnowledgeIndexKind where toJSON KnowledgeIndexKindKnowledgeIndex = String "KnowledgeIndex"

data KnowledgeIndexSpec = KnowledgeIndexSpec
  { knowledgeIndexSpecEmbedding :: KnowledgeIndexSpecEmbedding,
    knowledgeIndexSpecGraph :: Runner,
    knowledgeIndexSpecKnowledgeBase :: Text,
    knowledgeIndexSpecLibrarian :: KnowledgeIndexSpecLibrarian,
    knowledgeIndexSpecLogLevel :: LogLevel,
    knowledgeIndexSpecSmelter :: KnowledgeIndexSpecSmelter,
    knowledgeIndexSpecVectors :: KnowledgeIndexSpecVectors,
    knowledgeIndexSpecWeaver :: KnowledgeIndexSpecWeaver
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpec where parseJSON = checked "KnowledgeIndexSpec" $ withObject "KnowledgeIndexSpec" (\fields -> KnowledgeIndexSpec <$> (fields .: "embedding") <*> (fields .: "graph") <*> (fields .: "knowledgeBase") <*> (fields .: "librarian") <*> (fields .: "logLevel") <*> (fields .: "smelter") <*> (fields .: "vectors") <*> (fields .: "weaver"))

instance ToJSON KnowledgeIndexSpec where toJSON value = Object (KM.fromList (concat [[("embedding", toJSON (knowledgeIndexSpecEmbedding value))], [("graph", toJSON (knowledgeIndexSpecGraph value))], [("knowledgeBase", toJSON (knowledgeIndexSpecKnowledgeBase value))], [("librarian", toJSON (knowledgeIndexSpecLibrarian value))], [("logLevel", toJSON (knowledgeIndexSpecLogLevel value))], [("smelter", toJSON (knowledgeIndexSpecSmelter value))], [("vectors", toJSON (knowledgeIndexSpecVectors value))], [("weaver", toJSON (knowledgeIndexSpecWeaver value))]]))

data KnowledgeIndexSpecEmbedding = KnowledgeIndexSpecEmbedding
  { knowledgeIndexSpecEmbeddingApiKey :: Maybe SecretRef,
    knowledgeIndexSpecEmbeddingChunking :: KnowledgeIndexSpecEmbeddingChunking,
    knowledgeIndexSpecEmbeddingEndpoint :: Maybe Text,
    knowledgeIndexSpecEmbeddingModel :: Text,
    knowledgeIndexSpecEmbeddingType :: Text
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecEmbedding where parseJSON = checked "KnowledgeIndexSpecEmbedding" $ withObject "KnowledgeIndexSpecEmbedding" (\fields -> KnowledgeIndexSpecEmbedding <$> optional fields "apiKey" <*> (fields .: "chunking") <*> optional fields "endpoint" <*> (fields .: "model") <*> (fields .: "type"))

instance ToJSON KnowledgeIndexSpecEmbedding where toJSON value = Object (KM.fromList (concat [optionalPair "apiKey" (knowledgeIndexSpecEmbeddingApiKey value), [("chunking", toJSON (knowledgeIndexSpecEmbeddingChunking value))], optionalPair "endpoint" (knowledgeIndexSpecEmbeddingEndpoint value), [("model", toJSON (knowledgeIndexSpecEmbeddingModel value))], [("type", toJSON (knowledgeIndexSpecEmbeddingType value))]]))

data KnowledgeIndexSpecEmbeddingChunking = KnowledgeIndexSpecEmbeddingChunking
  { knowledgeIndexSpecEmbeddingChunkingChunkSize :: Integer,
    knowledgeIndexSpecEmbeddingChunkingOverlap :: Integer
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecEmbeddingChunking where parseJSON = checked "KnowledgeIndexSpecEmbeddingChunking" $ withObject "KnowledgeIndexSpecEmbeddingChunking" (\fields -> KnowledgeIndexSpecEmbeddingChunking <$> (fields .: "chunkSize") <*> (fields .: "overlap"))

instance ToJSON KnowledgeIndexSpecEmbeddingChunking where toJSON value = Object (KM.fromList (concat [[("chunkSize", toJSON (knowledgeIndexSpecEmbeddingChunkingChunkSize value))], [("overlap", toJSON (knowledgeIndexSpecEmbeddingChunkingOverlap value))]]))

data KnowledgeIndexSpecLibrarian = KnowledgeIndexSpecLibrarian
  { knowledgeIndexSpecLibrarianGather :: KnowledgeIndexSpecLibrarianGather,
    knowledgeIndexSpecLibrarianImage :: Image,
    knowledgeIndexSpecLibrarianResources :: Resources,
    knowledgeIndexSpecLibrarianSearch :: KnowledgeIndexSpecLibrarianSearch
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecLibrarian where parseJSON = checked "KnowledgeIndexSpecLibrarian" $ withObject "KnowledgeIndexSpecLibrarian" (\fields -> KnowledgeIndexSpecLibrarian <$> (fields .: "gather") <*> (fields .: "image") <*> (fields .: "resources") <*> (fields .: "search"))

instance ToJSON KnowledgeIndexSpecLibrarian where toJSON value = Object (KM.fromList (concat [[("gather", toJSON (knowledgeIndexSpecLibrarianGather value))], [("image", toJSON (knowledgeIndexSpecLibrarianImage value))], [("resources", toJSON (knowledgeIndexSpecLibrarianResources value))], [("search", toJSON (knowledgeIndexSpecLibrarianSearch value))]]))

data KnowledgeIndexSpecLibrarianGather = KnowledgeIndexSpecLibrarianGather
  { knowledgeIndexSpecLibrarianGatherSettleTimeoutMs :: Integer
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecLibrarianGather where parseJSON = checked "KnowledgeIndexSpecLibrarianGather" $ withObject "KnowledgeIndexSpecLibrarianGather" (\fields -> KnowledgeIndexSpecLibrarianGather <$> (fields .: "settleTimeoutMs"))

instance ToJSON KnowledgeIndexSpecLibrarianGather where toJSON value = Object (KM.fromList (concat [[("settleTimeoutMs", toJSON (knowledgeIndexSpecLibrarianGatherSettleTimeoutMs value))]]))

data KnowledgeIndexSpecLibrarianSearch = KnowledgeIndexSpecLibrarianSearch
  { knowledgeIndexSpecLibrarianSearchSemanticFloor :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecLibrarianSearch where parseJSON = checked "KnowledgeIndexSpecLibrarianSearch" $ withObject "KnowledgeIndexSpecLibrarianSearch" (\fields -> KnowledgeIndexSpecLibrarianSearch <$> (fields .: "semanticFloor"))

instance ToJSON KnowledgeIndexSpecLibrarianSearch where toJSON value = Object (KM.fromList (concat [[("semanticFloor", toJSON (knowledgeIndexSpecLibrarianSearchSemanticFloor value))]]))

data KnowledgeIndexSpecSmelter = KnowledgeIndexSpecSmelter
  { knowledgeIndexSpecSmelterImage :: Image,
    knowledgeIndexSpecSmelterPdfsAtOnce :: Integer,
    knowledgeIndexSpecSmelterResources :: Resources
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecSmelter where parseJSON = checked "KnowledgeIndexSpecSmelter" $ withObject "KnowledgeIndexSpecSmelter" (\fields -> KnowledgeIndexSpecSmelter <$> (fields .: "image") <*> (fields .: "pdfsAtOnce") <*> (fields .: "resources"))

instance ToJSON KnowledgeIndexSpecSmelter where toJSON value = Object (KM.fromList (concat [[("image", toJSON (knowledgeIndexSpecSmelterImage value))], [("pdfsAtOnce", toJSON (knowledgeIndexSpecSmelterPdfsAtOnce value))], [("resources", toJSON (knowledgeIndexSpecSmelterResources value))]]))

data KnowledgeIndexSpecVectors = KnowledgeIndexSpecVectors
  { knowledgeIndexSpecVectorsExternal :: Maybe KnowledgeIndexSpecVectorsExternal,
    knowledgeIndexSpecVectorsImage :: Maybe Image,
    knowledgeIndexSpecVectorsResources :: Maybe Resources,
    knowledgeIndexSpecVectorsShared :: Maybe KnowledgeIndexSpecVectorsShared,
    knowledgeIndexSpecVectorsType :: Text
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecVectors where parseJSON = checked "KnowledgeIndexSpecVectors" $ withObject "KnowledgeIndexSpecVectors" (\fields -> KnowledgeIndexSpecVectors <$> optional fields "external" <*> optional fields "image" <*> optional fields "resources" <*> optional fields "shared" <*> (fields .: "type"))

instance ToJSON KnowledgeIndexSpecVectors where toJSON value = Object (KM.fromList (concat [optionalPair "external" (knowledgeIndexSpecVectorsExternal value), optionalPair "image" (knowledgeIndexSpecVectorsImage value), optionalPair "resources" (knowledgeIndexSpecVectorsResources value), optionalPair "shared" (knowledgeIndexSpecVectorsShared value), [("type", toJSON (knowledgeIndexSpecVectorsType value))]]))

data KnowledgeIndexSpecVectorsExternal = KnowledgeIndexSpecVectorsExternal
  { knowledgeIndexSpecVectorsExternalHost :: Text,
    knowledgeIndexSpecVectorsExternalLibrarianToken :: SecretRef,
    knowledgeIndexSpecVectorsExternalPort :: Integer,
    knowledgeIndexSpecVectorsExternalSmelterToken :: SecretRef
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecVectorsExternal where parseJSON = checked "KnowledgeIndexSpecVectorsExternal" $ withObject "KnowledgeIndexSpecVectorsExternal" (\fields -> KnowledgeIndexSpecVectorsExternal <$> (fields .: "host") <*> (fields .: "librarianToken") <*> (fields .: "port") <*> (fields .: "smelterToken"))

instance ToJSON KnowledgeIndexSpecVectorsExternal where toJSON value = Object (KM.fromList (concat [[("host", toJSON (knowledgeIndexSpecVectorsExternalHost value))], [("librarianToken", toJSON (knowledgeIndexSpecVectorsExternalLibrarianToken value))], [("port", toJSON (knowledgeIndexSpecVectorsExternalPort value))], [("smelterToken", toJSON (knowledgeIndexSpecVectorsExternalSmelterToken value))]]))

data KnowledgeIndexSpecVectorsShared = KnowledgeIndexSpecVectorsShared deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecVectorsShared where parseJSON = checked "KnowledgeIndexSpecVectorsShared" $ withObject "KnowledgeIndexSpecVectorsShared" (\_ -> pure KnowledgeIndexSpecVectorsShared)

instance ToJSON KnowledgeIndexSpecVectorsShared where toJSON _ = Object (KM.fromList (concat []))

data KnowledgeIndexSpecWeaver = KnowledgeIndexSpecWeaver
  { knowledgeIndexSpecWeaverImage :: Image,
    knowledgeIndexSpecWeaverResources :: Resources
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecWeaver where parseJSON = checked "KnowledgeIndexSpecWeaver" $ withObject "KnowledgeIndexSpecWeaver" (\fields -> KnowledgeIndexSpecWeaver <$> (fields .: "image") <*> (fields .: "resources"))

instance ToJSON KnowledgeIndexSpecWeaver where toJSON value = Object (KM.fromList (concat [[("image", toJSON (knowledgeIndexSpecWeaverImage value))], [("resources", toJSON (knowledgeIndexSpecWeaverResources value))]]))
