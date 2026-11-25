-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KnowledgeIndex (KnowledgeIndex (..), KnowledgeIndexKind (..), knowledgeIndexKindText, KnowledgeIndexSpec (..), KnowledgeIndexSpecEmbedding (..), KnowledgeIndexSpecEmbeddingChunking (..), KnowledgeIndexSpecLibrarian (..), KnowledgeIndexSpecLibrarianGather (..), KnowledgeIndexSpecLibrarianSearch (..), KnowledgeIndexSpecSmelter (..), KnowledgeIndexSpecVectors (..), KnowledgeIndexSpecVectorsExternal (..), KnowledgeIndexSpecVectorsShared (..), KnowledgeIndexSpecWeaver (..)) where

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

knowledgeIndexKindText :: KnowledgeIndexKind -> Text
knowledgeIndexKindText KnowledgeIndexKindKnowledgeIndex = "KnowledgeIndex"

data KnowledgeIndexSpec = KnowledgeIndexSpec
  { knowledgeIndexSpecKnowledgeBase :: Text,
    knowledgeIndexSpecLogLevel :: LogLevel,
    knowledgeIndexSpecGraph :: Runner,
    knowledgeIndexSpecVectors :: KnowledgeIndexSpecVectors,
    knowledgeIndexSpecEmbedding :: KnowledgeIndexSpecEmbedding,
    knowledgeIndexSpecLibrarian :: KnowledgeIndexSpecLibrarian,
    knowledgeIndexSpecSmelter :: KnowledgeIndexSpecSmelter,
    knowledgeIndexSpecWeaver :: KnowledgeIndexSpecWeaver
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpec where parseJSON = checked "KnowledgeIndexSpec" $ withObject "KnowledgeIndexSpec" (\fields -> KnowledgeIndexSpec <$> (fields .: "knowledgeBase") <*> (fields .: "logLevel") <*> (fields .: "graph") <*> (fields .: "vectors") <*> (fields .: "embedding") <*> (fields .: "librarian") <*> (fields .: "smelter") <*> (fields .: "weaver"))

instance ToJSON KnowledgeIndexSpec where toJSON value = Object (KM.fromList (concat [[("knowledgeBase", toJSON (knowledgeIndexSpecKnowledgeBase value))], [("logLevel", toJSON (knowledgeIndexSpecLogLevel value))], [("graph", toJSON (knowledgeIndexSpecGraph value))], [("vectors", toJSON (knowledgeIndexSpecVectors value))], [("embedding", toJSON (knowledgeIndexSpecEmbedding value))], [("librarian", toJSON (knowledgeIndexSpecLibrarian value))], [("smelter", toJSON (knowledgeIndexSpecSmelter value))], [("weaver", toJSON (knowledgeIndexSpecWeaver value))]]))

data KnowledgeIndexSpecEmbedding = KnowledgeIndexSpecEmbedding
  { knowledgeIndexSpecEmbeddingType :: Text,
    knowledgeIndexSpecEmbeddingModel :: Text,
    knowledgeIndexSpecEmbeddingChunking :: KnowledgeIndexSpecEmbeddingChunking,
    knowledgeIndexSpecEmbeddingEndpoint :: Maybe Text,
    knowledgeIndexSpecEmbeddingApiKey :: Maybe SecretRef
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecEmbedding where parseJSON = checked "KnowledgeIndexSpecEmbedding" $ withObject "KnowledgeIndexSpecEmbedding" (\fields -> KnowledgeIndexSpecEmbedding <$> (fields .: "type") <*> (fields .: "model") <*> (fields .: "chunking") <*> optional fields "endpoint" <*> optional fields "apiKey")

instance ToJSON KnowledgeIndexSpecEmbedding where toJSON value = Object (KM.fromList (concat [[("type", toJSON (knowledgeIndexSpecEmbeddingType value))], [("model", toJSON (knowledgeIndexSpecEmbeddingModel value))], [("chunking", toJSON (knowledgeIndexSpecEmbeddingChunking value))], optionalPair "endpoint" (knowledgeIndexSpecEmbeddingEndpoint value), optionalPair "apiKey" (knowledgeIndexSpecEmbeddingApiKey value)]))

data KnowledgeIndexSpecEmbeddingChunking = KnowledgeIndexSpecEmbeddingChunking
  { knowledgeIndexSpecEmbeddingChunkingChunkSize :: Integer,
    knowledgeIndexSpecEmbeddingChunkingOverlap :: Integer
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecEmbeddingChunking where parseJSON = checked "KnowledgeIndexSpecEmbeddingChunking" $ withObject "KnowledgeIndexSpecEmbeddingChunking" (\fields -> KnowledgeIndexSpecEmbeddingChunking <$> (fields .: "chunkSize") <*> (fields .: "overlap"))

instance ToJSON KnowledgeIndexSpecEmbeddingChunking where toJSON value = Object (KM.fromList (concat [[("chunkSize", toJSON (knowledgeIndexSpecEmbeddingChunkingChunkSize value))], [("overlap", toJSON (knowledgeIndexSpecEmbeddingChunkingOverlap value))]]))

data KnowledgeIndexSpecLibrarian = KnowledgeIndexSpecLibrarian
  { knowledgeIndexSpecLibrarianImage :: Image,
    knowledgeIndexSpecLibrarianResources :: Resources,
    knowledgeIndexSpecLibrarianGather :: KnowledgeIndexSpecLibrarianGather,
    knowledgeIndexSpecLibrarianSearch :: KnowledgeIndexSpecLibrarianSearch
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecLibrarian where parseJSON = checked "KnowledgeIndexSpecLibrarian" $ withObject "KnowledgeIndexSpecLibrarian" (\fields -> KnowledgeIndexSpecLibrarian <$> (fields .: "image") <*> (fields .: "resources") <*> (fields .: "gather") <*> (fields .: "search"))

instance ToJSON KnowledgeIndexSpecLibrarian where toJSON value = Object (KM.fromList (concat [[("image", toJSON (knowledgeIndexSpecLibrarianImage value))], [("resources", toJSON (knowledgeIndexSpecLibrarianResources value))], [("gather", toJSON (knowledgeIndexSpecLibrarianGather value))], [("search", toJSON (knowledgeIndexSpecLibrarianSearch value))]]))

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
    knowledgeIndexSpecSmelterResources :: Resources,
    knowledgeIndexSpecSmelterPdfsAtOnce :: Integer
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecSmelter where parseJSON = checked "KnowledgeIndexSpecSmelter" $ withObject "KnowledgeIndexSpecSmelter" (\fields -> KnowledgeIndexSpecSmelter <$> (fields .: "image") <*> (fields .: "resources") <*> (fields .: "pdfsAtOnce"))

instance ToJSON KnowledgeIndexSpecSmelter where toJSON value = Object (KM.fromList (concat [[("image", toJSON (knowledgeIndexSpecSmelterImage value))], [("resources", toJSON (knowledgeIndexSpecSmelterResources value))], [("pdfsAtOnce", toJSON (knowledgeIndexSpecSmelterPdfsAtOnce value))]]))

data KnowledgeIndexSpecVectors = KnowledgeIndexSpecVectors
  { knowledgeIndexSpecVectorsType :: Text,
    knowledgeIndexSpecVectorsShared :: Maybe KnowledgeIndexSpecVectorsShared,
    knowledgeIndexSpecVectorsImage :: Maybe Image,
    knowledgeIndexSpecVectorsResources :: Maybe Resources,
    knowledgeIndexSpecVectorsExternal :: Maybe KnowledgeIndexSpecVectorsExternal
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecVectors where parseJSON = checked "KnowledgeIndexSpecVectors" $ withObject "KnowledgeIndexSpecVectors" (\fields -> KnowledgeIndexSpecVectors <$> (fields .: "type") <*> optional fields "shared" <*> optional fields "image" <*> optional fields "resources" <*> optional fields "external")

instance ToJSON KnowledgeIndexSpecVectors where toJSON value = Object (KM.fromList (concat [[("type", toJSON (knowledgeIndexSpecVectorsType value))], optionalPair "shared" (knowledgeIndexSpecVectorsShared value), optionalPair "image" (knowledgeIndexSpecVectorsImage value), optionalPair "resources" (knowledgeIndexSpecVectorsResources value), optionalPair "external" (knowledgeIndexSpecVectorsExternal value)]))

data KnowledgeIndexSpecVectorsExternal = KnowledgeIndexSpecVectorsExternal
  { knowledgeIndexSpecVectorsExternalHost :: Text,
    knowledgeIndexSpecVectorsExternalPort :: Integer,
    knowledgeIndexSpecVectorsExternalSmelterToken :: SecretRef,
    knowledgeIndexSpecVectorsExternalLibrarianToken :: SecretRef
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeIndexSpecVectorsExternal where parseJSON = checked "KnowledgeIndexSpecVectorsExternal" $ withObject "KnowledgeIndexSpecVectorsExternal" (\fields -> KnowledgeIndexSpecVectorsExternal <$> (fields .: "host") <*> (fields .: "port") <*> (fields .: "smelterToken") <*> (fields .: "librarianToken"))

instance ToJSON KnowledgeIndexSpecVectorsExternal where toJSON value = Object (KM.fromList (concat [[("host", toJSON (knowledgeIndexSpecVectorsExternalHost value))], [("port", toJSON (knowledgeIndexSpecVectorsExternalPort value))], [("smelterToken", toJSON (knowledgeIndexSpecVectorsExternalSmelterToken value))], [("librarianToken", toJSON (knowledgeIndexSpecVectorsExternalLibrarianToken value))]]))

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
