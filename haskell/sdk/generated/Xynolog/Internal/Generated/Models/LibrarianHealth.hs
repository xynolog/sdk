-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LibrarianHealth (LibrarianHealth (..), LibrarianHealthActorsItem (..), LibrarianHealthStatus (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbDid

data LibrarianHealth = LibrarianHealth
  { librarianHealthActors :: [LibrarianHealthActorsItem],
    librarianHealthKb :: KbDid,
    librarianHealthStatus :: LibrarianHealthStatus
  }
  deriving (Eq, Show)

instance FromJSON LibrarianHealth where parseJSON = checked "LibrarianHealth" $ withObject "LibrarianHealth" (\fields -> LibrarianHealth <$> (fields .: "actors") <*> (fields .: "kb") <*> (fields .: "status"))

instance ToJSON LibrarianHealth where toJSON value = Object (KM.fromList (concat [[("actors", toJSON (librarianHealthActors value))], [("kb", toJSON (librarianHealthKb value))], [("status", toJSON (librarianHealthStatus value))]]))

data LibrarianHealthActorsItem = LibrarianHealthActorsItemMatcher | LibrarianHealthActorsItemGatherer deriving (Eq, Show)

instance FromJSON LibrarianHealthActorsItem where parseJSON = checked "LibrarianHealthActorsItem" $ \value -> if value == String "matcher" then pure LibrarianHealthActorsItemMatcher else if value == String "gatherer" then pure LibrarianHealthActorsItemGatherer else fail "unknown enumeration member"

instance ToJSON LibrarianHealthActorsItem where
  toJSON LibrarianHealthActorsItemMatcher = String "matcher"
  toJSON LibrarianHealthActorsItemGatherer = String "gatherer"

data LibrarianHealthStatus = LibrarianHealthStatusOk deriving (Eq, Show)

instance FromJSON LibrarianHealthStatus where parseJSON = checked "LibrarianHealthStatus" $ \value -> if value == String "ok" then pure LibrarianHealthStatusOk else fail "unknown enumeration member"

instance ToJSON LibrarianHealthStatus where toJSON LibrarianHealthStatusOk = String "ok"
