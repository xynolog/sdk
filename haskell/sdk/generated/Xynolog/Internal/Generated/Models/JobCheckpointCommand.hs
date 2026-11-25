-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobCheckpointCommand (JobCheckpointCommand (..), JobCheckpointCommandUnitCursors (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.UnitCursor
import Xynolog.Internal.Generated.Models.UserId

data JobCheckpointCommand = JobCheckpointCommand
  { jobCheckpointCommandUserId :: Maybe UserId,
    jobCheckpointCommandCompletedUnits :: [Text],
    jobCheckpointCommandJobId :: JobId,
    jobCheckpointCommandUnitCursors :: Maybe JobCheckpointCommandUnitCursors
  }
  deriving (Eq, Show)

instance FromJSON JobCheckpointCommand where parseJSON = checked "JobCheckpointCommand" $ withObject "JobCheckpointCommand" (\fields -> JobCheckpointCommand <$> optional fields "_userId" <*> (fields .: "completedUnits") <*> (fields .: "jobId") <*> optional fields "unitCursors")

instance ToJSON JobCheckpointCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (jobCheckpointCommandUserId value), [("completedUnits", toJSON (jobCheckpointCommandCompletedUnits value))], [("jobId", toJSON (jobCheckpointCommandJobId value))], optionalPair "unitCursors" (jobCheckpointCommandUnitCursors value)]))

data JobCheckpointCommandUnitCursors = JobCheckpointCommandUnitCursors
  { jobCheckpointCommandUnitCursorsAdditionalProperties :: KM.KeyMap UnitCursor
  }
  deriving (Eq, Show)

instance FromJSON JobCheckpointCommandUnitCursors where parseJSON = checked "JobCheckpointCommandUnitCursors" $ withObject "JobCheckpointCommandUnitCursors" (\fields -> JobCheckpointCommandUnitCursors <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobCheckpointCommandUnitCursors where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobCheckpointCommandUnitCursorsAdditionalProperties value)))
