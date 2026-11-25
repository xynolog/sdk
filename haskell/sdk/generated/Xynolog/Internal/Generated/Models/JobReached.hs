-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobReached (JobReached (..), JobReachedUnitCursors (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.UnitCursor

data JobReached = JobReached
  { jobReachedCompletedUnits :: Maybe [Text],
    jobReachedUnitCursors :: Maybe JobReachedUnitCursors
  }
  deriving (Eq, Show)

instance FromJSON JobReached where parseJSON = checked "JobReached" $ withObject "JobReached" (\fields -> JobReached <$> optional fields "completedUnits" <*> optional fields "unitCursors")

instance ToJSON JobReached where toJSON value = Object (KM.fromList (concat [optionalPair "completedUnits" (jobReachedCompletedUnits value), optionalPair "unitCursors" (jobReachedUnitCursors value)]))

data JobReachedUnitCursors = JobReachedUnitCursors
  { jobReachedUnitCursorsAdditionalProperties :: KM.KeyMap UnitCursor
  }
  deriving (Eq, Show)

instance FromJSON JobReachedUnitCursors where parseJSON = checked "JobReachedUnitCursors" $ withObject "JobReachedUnitCursors" (\fields -> JobReachedUnitCursors <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobReachedUnitCursors where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobReachedUnitCursorsAdditionalProperties value)))
