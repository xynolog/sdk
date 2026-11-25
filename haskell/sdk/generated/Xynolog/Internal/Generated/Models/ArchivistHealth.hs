-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistHealth (ArchivistHealth (..), ArchivistHealthActorsItem (..), archivistHealthActorsItemText, ArchivistHealthStatus (..), archivistHealthStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ArchivistHealth = ArchivistHealth
  { archivistHealthStatus :: ArchivistHealthStatus,
    archivistHealthActors :: [ArchivistHealthActorsItem]
  }
  deriving (Eq, Show)

instance FromJSON ArchivistHealth where parseJSON = checked "ArchivistHealth" $ withObject "ArchivistHealth" (\fields -> ArchivistHealth <$> (fields .: "status") <*> (fields .: "actors"))

instance ToJSON ArchivistHealth where toJSON value = Object (KM.fromList (concat [[("status", toJSON (archivistHealthStatus value))], [("actors", toJSON (archivistHealthActors value))]]))

data ArchivistHealthActorsItem = ArchivistHealthActorsItemStower | ArchivistHealthActorsItemBrowser | ArchivistHealthActorsItemCloneTokenManager deriving (Eq, Show)

instance FromJSON ArchivistHealthActorsItem where parseJSON = checked "ArchivistHealthActorsItem" $ \value -> if value == String "stower" then pure ArchivistHealthActorsItemStower else if value == String "browser" then pure ArchivistHealthActorsItemBrowser else if value == String "cloneTokenManager" then pure ArchivistHealthActorsItemCloneTokenManager else fail "unknown enumeration member"

instance ToJSON ArchivistHealthActorsItem where
  toJSON ArchivistHealthActorsItemStower = String "stower"
  toJSON ArchivistHealthActorsItemBrowser = String "browser"
  toJSON ArchivistHealthActorsItemCloneTokenManager = String "cloneTokenManager"

archivistHealthActorsItemText :: ArchivistHealthActorsItem -> Text
archivistHealthActorsItemText ArchivistHealthActorsItemStower = "stower"
archivistHealthActorsItemText ArchivistHealthActorsItemBrowser = "browser"
archivistHealthActorsItemText ArchivistHealthActorsItemCloneTokenManager = "cloneTokenManager"

data ArchivistHealthStatus = ArchivistHealthStatusOk deriving (Eq, Show)

instance FromJSON ArchivistHealthStatus where parseJSON = checked "ArchivistHealthStatus" $ \value -> if value == String "ok" then pure ArchivistHealthStatusOk else fail "unknown enumeration member"

instance ToJSON ArchivistHealthStatus where toJSON ArchivistHealthStatusOk = String "ok"

archivistHealthStatusText :: ArchivistHealthStatus -> Text
archivistHealthStatusText ArchivistHealthStatusOk = "ok"
