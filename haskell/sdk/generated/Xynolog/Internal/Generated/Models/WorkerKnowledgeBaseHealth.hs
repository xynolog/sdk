-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerKnowledgeBaseHealth (WorkerKnowledgeBaseHealth (..), WorkerKnowledgeBaseHealthState (..), workerKnowledgeBaseHealthStateText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.WorkerEngineHealth

data WorkerKnowledgeBaseHealth = WorkerKnowledgeBaseHealth
  { workerKnowledgeBaseHealthDid :: Maybe Text,
    workerKnowledgeBaseHealthDomain :: Text,
    workerKnowledgeBaseHealthEngines :: Maybe [WorkerEngineHealth],
    workerKnowledgeBaseHealthState :: WorkerKnowledgeBaseHealthState
  }
  deriving (Eq, Show)

instance FromJSON WorkerKnowledgeBaseHealth where parseJSON = checked "WorkerKnowledgeBaseHealth" $ withObject "WorkerKnowledgeBaseHealth" (\fields -> WorkerKnowledgeBaseHealth <$> optional fields "did" <*> (fields .: "domain") <*> optional fields "engines" <*> (fields .: "state"))

instance ToJSON WorkerKnowledgeBaseHealth where toJSON value = Object (KM.fromList (concat [optionalPair "did" (workerKnowledgeBaseHealthDid value), [("domain", toJSON (workerKnowledgeBaseHealthDomain value))], optionalPair "engines" (workerKnowledgeBaseHealthEngines value), [("state", toJSON (workerKnowledgeBaseHealthState value))]]))

data WorkerKnowledgeBaseHealthState = WorkerKnowledgeBaseHealthStateStarting | WorkerKnowledgeBaseHealthStateWorking | WorkerKnowledgeBaseHealthStateRefused deriving (Eq, Show)

instance FromJSON WorkerKnowledgeBaseHealthState where parseJSON = checked "WorkerKnowledgeBaseHealthState" $ \value -> if value == String "starting" then pure WorkerKnowledgeBaseHealthStateStarting else if value == String "working" then pure WorkerKnowledgeBaseHealthStateWorking else if value == String "refused" then pure WorkerKnowledgeBaseHealthStateRefused else fail "unknown enumeration member"

instance ToJSON WorkerKnowledgeBaseHealthState where
  toJSON WorkerKnowledgeBaseHealthStateStarting = String "starting"
  toJSON WorkerKnowledgeBaseHealthStateWorking = String "working"
  toJSON WorkerKnowledgeBaseHealthStateRefused = String "refused"

workerKnowledgeBaseHealthStateText :: WorkerKnowledgeBaseHealthState -> Text
workerKnowledgeBaseHealthStateText WorkerKnowledgeBaseHealthStateStarting = "starting"
workerKnowledgeBaseHealthStateText WorkerKnowledgeBaseHealthStateWorking = "working"
workerKnowledgeBaseHealthStateText WorkerKnowledgeBaseHealthStateRefused = "refused"
