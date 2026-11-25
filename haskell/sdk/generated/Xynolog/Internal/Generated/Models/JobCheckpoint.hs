-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobCheckpoint (JobCheckpoint (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.UnitCursor

data JobCheckpoint = JobCheckpoint
  { jobCheckpointCompletedUnits :: [Text],
    jobCheckpointUnitCursors :: Maybe (KM.KeyMap UnitCursor)
  }
  deriving (Eq, Show)

instance FromJSON JobCheckpoint where parseJSON = checked "JobCheckpoint" $ withObject "JobCheckpoint" (\fields -> JobCheckpoint <$> (fields .: "completedUnits") <*> optional fields "unitCursors")

instance ToJSON JobCheckpoint where toJSON value = Object (KM.fromList (concat [[("completedUnits", toJSON (jobCheckpointCompletedUnits value))], optionalPair "unitCursors" (jobCheckpointUnitCursors value)]))
