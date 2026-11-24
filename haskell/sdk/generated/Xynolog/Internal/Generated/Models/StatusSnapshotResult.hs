-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StatusSnapshotResult (StatusSnapshotResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KnowledgeBaseStatus
import Xynolog.Internal.Generated.Models.ServiceStatus

data StatusSnapshotResult = StatusSnapshotResult
  { statusSnapshotResultKnowledgeBases :: [KnowledgeBaseStatus],
    statusSnapshotResultShared :: [ServiceStatus]
  }
  deriving (Eq, Show)

instance FromJSON StatusSnapshotResult where parseJSON = checked "StatusSnapshotResult" $ withObject "StatusSnapshotResult" (\fields -> StatusSnapshotResult <$> (fields .: "knowledgeBases") <*> (fields .: "shared"))

instance ToJSON StatusSnapshotResult where toJSON value = Object (KM.fromList (concat [[("knowledgeBases", toJSON (statusSnapshotResultKnowledgeBases value))], [("shared", toJSON (statusSnapshotResultShared value))]]))
