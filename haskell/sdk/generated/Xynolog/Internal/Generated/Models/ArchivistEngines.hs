-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistEngines (ArchivistEngines (..), ArchivistEnginesActors (..), ArchivistEnginesJobs (..), ArchivistEnginesJobsMark (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Engine

data ArchivistEngines = ArchivistEngines
  { archivistEnginesJobs :: ArchivistEnginesJobs,
    archivistEnginesActors :: ArchivistEnginesActors
  }
  deriving (Eq, Show)

instance FromJSON ArchivistEngines where parseJSON = checked "ArchivistEngines" $ withObject "ArchivistEngines" (\fields -> ArchivistEngines <$> (fields .: "jobs") <*> (fields .: "actors"))

instance ToJSON ArchivistEngines where toJSON value = Object (KM.fromList (concat [[("jobs", toJSON (archivistEnginesJobs value))], [("actors", toJSON (archivistEnginesActors value))]]))

data ArchivistEnginesActors = ArchivistEnginesActors
  { archivistEnginesActorsGatherer :: Maybe Engine,
    archivistEnginesActorsMatcher :: Maybe Engine
  }
  deriving (Eq, Show)

instance FromJSON ArchivistEnginesActors where parseJSON = checked "ArchivistEnginesActors" $ withObject "ArchivistEnginesActors" (\fields -> ArchivistEnginesActors <$> optional fields "gatherer" <*> optional fields "matcher")

instance ToJSON ArchivistEnginesActors where toJSON value = Object (KM.fromList (concat [optionalPair "gatherer" (archivistEnginesActorsGatherer value), optionalPair "matcher" (archivistEnginesActorsMatcher value)]))

data ArchivistEnginesJobs = ArchivistEnginesJobs
  { archivistEnginesJobsMark :: Maybe ArchivistEnginesJobsMark,
    archivistEnginesJobsYield :: Maybe Engine
  }
  deriving (Eq, Show)

instance FromJSON ArchivistEnginesJobs where parseJSON = checked "ArchivistEnginesJobs" $ withObject "ArchivistEnginesJobs" (\fields -> ArchivistEnginesJobs <$> optional fields "mark" <*> optional fields "yield")

instance ToJSON ArchivistEnginesJobs where toJSON value = Object (KM.fromList (concat [optionalPair "mark" (archivistEnginesJobsMark value), optionalPair "yield" (archivistEnginesJobsYield value)]))

data ArchivistEnginesJobsMark = ArchivistEnginesJobsMark
  { archivistEnginesJobsMarkHighlighting :: Maybe Engine,
    archivistEnginesJobsMarkCommenting :: Maybe Engine,
    archivistEnginesJobsMarkAssessing :: Maybe Engine,
    archivistEnginesJobsMarkLinking :: Maybe Engine,
    archivistEnginesJobsMarkTagging :: Maybe Engine
  }
  deriving (Eq, Show)

instance FromJSON ArchivistEnginesJobsMark where parseJSON = checked "ArchivistEnginesJobsMark" $ withObject "ArchivistEnginesJobsMark" (\fields -> ArchivistEnginesJobsMark <$> optional fields "highlighting" <*> optional fields "commenting" <*> optional fields "assessing" <*> optional fields "linking" <*> optional fields "tagging")

instance ToJSON ArchivistEnginesJobsMark where toJSON value = Object (KM.fromList (concat [optionalPair "highlighting" (archivistEnginesJobsMarkHighlighting value), optionalPair "commenting" (archivistEnginesJobsMarkCommenting value), optionalPair "assessing" (archivistEnginesJobsMarkAssessing value), optionalPair "linking" (archivistEnginesJobsMarkLinking value), optionalPair "tagging" (archivistEnginesJobsMarkTagging value)]))
