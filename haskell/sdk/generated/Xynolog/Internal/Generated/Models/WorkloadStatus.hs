-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkloadStatus (WorkloadStatus (..), WorkloadStatusLedger (..), WorkloadStatusQueue (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data WorkloadStatus = WorkloadStatus
  { workloadStatusLedger :: Maybe WorkloadStatusLedger,
    workloadStatusQueue :: Maybe WorkloadStatusQueue
  }
  deriving (Eq, Show)

instance FromJSON WorkloadStatus where parseJSON = checked "WorkloadStatus" $ withObject "WorkloadStatus" (\fields -> WorkloadStatus <$> optional fields "ledger" <*> optional fields "queue")

instance ToJSON WorkloadStatus where toJSON value = Object (KM.fromList (concat [optionalPair "ledger" (workloadStatusLedger value), optionalPair "queue" (workloadStatusQueue value)]))

data WorkloadStatusLedger = WorkloadStatusLedger
  { workloadStatusLedgerCapacity :: Integer,
    workloadStatusLedgerClaims :: Integer
  }
  deriving (Eq, Show)

instance FromJSON WorkloadStatusLedger where parseJSON = checked "WorkloadStatusLedger" $ withObject "WorkloadStatusLedger" (\fields -> WorkloadStatusLedger <$> (fields .: "capacity") <*> (fields .: "claims"))

instance ToJSON WorkloadStatusLedger where toJSON value = Object (KM.fromList (concat [[("capacity", toJSON (workloadStatusLedgerCapacity value))], [("claims", toJSON (workloadStatusLedgerClaims value))]]))

data WorkloadStatusQueue = WorkloadStatusQueue
  { workloadStatusQueueCompleted :: Maybe Integer,
    workloadStatusQueueFailed :: Maybe Integer,
    workloadStatusQueuePending :: Integer,
    workloadStatusQueueRunning :: Integer
  }
  deriving (Eq, Show)

instance FromJSON WorkloadStatusQueue where parseJSON = checked "WorkloadStatusQueue" $ withObject "WorkloadStatusQueue" (\fields -> WorkloadStatusQueue <$> optional fields "completed" <*> optional fields "failed" <*> (fields .: "pending") <*> (fields .: "running"))

instance ToJSON WorkloadStatusQueue where toJSON value = Object (KM.fromList (concat [optionalPair "completed" (workloadStatusQueueCompleted value), optionalPair "failed" (workloadStatusQueueFailed value), [("pending", toJSON (workloadStatusQueuePending value))], [("running", toJSON (workloadStatusQueueRunning value))]]))
