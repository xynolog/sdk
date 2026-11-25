-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistEventsResponse (ArchivistEventsResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.StoredEventResponse

data ArchivistEventsResponse = ArchivistEventsResponse
  { archivistEventsResponseEvents :: [StoredEventResponse],
    archivistEventsResponseLastSequence :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ArchivistEventsResponse where parseJSON = checked "ArchivistEventsResponse" $ withObject "ArchivistEventsResponse" (\fields -> ArchivistEventsResponse <$> (fields .: "events") <*> (fields .: "lastSequence"))

instance ToJSON ArchivistEventsResponse where toJSON value = Object (KM.fromList (concat [[("events", toJSON (archivistEventsResponseEvents value))], [("lastSequence", toJSON (archivistEventsResponseLastSequence value))]]))
