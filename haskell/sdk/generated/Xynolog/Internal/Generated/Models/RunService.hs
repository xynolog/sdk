-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RunService (RunService (..), runServiceText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data RunService = RunServiceArchivist | RunServiceDispatcher | RunServiceGateway | RunServiceLibrarian | RunServiceSmelter | RunServiceWeaver | RunServiceWorker deriving (Eq, Show)

instance FromJSON RunService where parseJSON = checked "RunService" $ \value -> if value == String "archivist" then pure RunServiceArchivist else if value == String "dispatcher" then pure RunServiceDispatcher else if value == String "gateway" then pure RunServiceGateway else if value == String "librarian" then pure RunServiceLibrarian else if value == String "smelter" then pure RunServiceSmelter else if value == String "weaver" then pure RunServiceWeaver else if value == String "worker" then pure RunServiceWorker else fail "unknown enumeration member"

instance ToJSON RunService where
  toJSON RunServiceArchivist = String "archivist"
  toJSON RunServiceDispatcher = String "dispatcher"
  toJSON RunServiceGateway = String "gateway"
  toJSON RunServiceLibrarian = String "librarian"
  toJSON RunServiceSmelter = String "smelter"
  toJSON RunServiceWeaver = String "weaver"
  toJSON RunServiceWorker = String "worker"

runServiceText :: RunService -> Text
runServiceText RunServiceArchivist = "archivist"
runServiceText RunServiceDispatcher = "dispatcher"
runServiceText RunServiceGateway = "gateway"
runServiceText RunServiceLibrarian = "librarian"
runServiceText RunServiceSmelter = "smelter"
runServiceText RunServiceWeaver = "weaver"
runServiceText RunServiceWorker = "worker"
