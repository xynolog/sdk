-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobFailure (JobFailure (..), JobFailureUnitCursors (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FailureClass
import Xynolog.Internal.Generated.Models.UnitCursor

data JobFailure = JobFailure
  { jobFailureCompletedUnits :: Maybe [Text],
    jobFailureUnitCursors :: Maybe JobFailureUnitCursors,
    jobFailureFailureClass :: Maybe FailureClass
  }
  deriving (Eq, Show)

instance FromJSON JobFailure where parseJSON = checked "JobFailure" $ withObject "JobFailure" (\fields -> JobFailure <$> optional fields "completedUnits" <*> optional fields "unitCursors" <*> optional fields "failureClass")

instance ToJSON JobFailure where toJSON value = Object (KM.fromList (concat [optionalPair "completedUnits" (jobFailureCompletedUnits value), optionalPair "unitCursors" (jobFailureUnitCursors value), optionalPair "failureClass" (jobFailureFailureClass value)]))

data JobFailureUnitCursors = JobFailureUnitCursors
  { jobFailureUnitCursorsAdditionalProperties :: KM.KeyMap UnitCursor
  }
  deriving (Eq, Show)

instance FromJSON JobFailureUnitCursors where parseJSON = checked "JobFailureUnitCursors" $ withObject "JobFailureUnitCursors" (\fields -> JobFailureUnitCursors <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON JobFailureUnitCursors where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (jobFailureUnitCursorsAdditionalProperties value)))
