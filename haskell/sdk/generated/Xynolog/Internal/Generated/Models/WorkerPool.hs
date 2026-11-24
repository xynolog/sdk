-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerPool (WorkerPool (..), WorkerPoolKind (..), workerPoolKindText, WorkerPoolSpec (..), WorkerPoolSpecWorker (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Image
import Xynolog.Internal.Generated.Models.LogLevel
import Xynolog.Internal.Generated.Models.Metadata
import Xynolog.Internal.Generated.Models.Resources
import Xynolog.Internal.Generated.Models.StackApiVersion

data WorkerPool = WorkerPool
  { workerPoolApiVersion :: StackApiVersion,
    workerPoolKind :: WorkerPoolKind,
    workerPoolMetadata :: Metadata,
    workerPoolSpec :: WorkerPoolSpec
  }
  deriving (Eq, Show)

instance FromJSON WorkerPool where parseJSON = checked "WorkerPool" $ withObject "WorkerPool" (\fields -> WorkerPool <$> (fields .: "apiVersion") <*> (fields .: "kind") <*> (fields .: "metadata") <*> (fields .: "spec"))

instance ToJSON WorkerPool where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (workerPoolApiVersion value))], [("kind", toJSON (workerPoolKind value))], [("metadata", toJSON (workerPoolMetadata value))], [("spec", toJSON (workerPoolSpec value))]]))

data WorkerPoolKind = WorkerPoolKindWorkerPool deriving (Eq, Show)

instance FromJSON WorkerPoolKind where parseJSON = checked "WorkerPoolKind" $ \value -> if value == String "WorkerPool" then pure WorkerPoolKindWorkerPool else fail "unknown enumeration member"

instance ToJSON WorkerPoolKind where toJSON WorkerPoolKindWorkerPool = String "WorkerPool"

workerPoolKindText :: WorkerPoolKind -> Text
workerPoolKindText WorkerPoolKindWorkerPool = "WorkerPool"

data WorkerPoolSpec = WorkerPoolSpec
  { workerPoolSpecLogLevel :: LogLevel,
    workerPoolSpecWorker :: WorkerPoolSpecWorker
  }
  deriving (Eq, Show)

instance FromJSON WorkerPoolSpec where parseJSON = checked "WorkerPoolSpec" $ withObject "WorkerPoolSpec" (\fields -> WorkerPoolSpec <$> (fields .: "logLevel") <*> (fields .: "worker"))

instance ToJSON WorkerPoolSpec where toJSON value = Object (KM.fromList (concat [[("logLevel", toJSON (workerPoolSpecLogLevel value))], [("worker", toJSON (workerPoolSpecWorker value))]]))

data WorkerPoolSpecWorker = WorkerPoolSpecWorker
  { workerPoolSpecWorkerImage :: Image,
    workerPoolSpecWorkerResources :: Resources
  }
  deriving (Eq, Show)

instance FromJSON WorkerPoolSpecWorker where parseJSON = checked "WorkerPoolSpecWorker" $ withObject "WorkerPoolSpecWorker" (\fields -> WorkerPoolSpecWorker <$> (fields .: "image") <*> (fields .: "resources"))

instance ToJSON WorkerPoolSpecWorker where toJSON value = Object (KM.fromList (concat [[("image", toJSON (workerPoolSpecWorkerImage value))], [("resources", toJSON (workerPoolSpecWorkerResources value))]]))
