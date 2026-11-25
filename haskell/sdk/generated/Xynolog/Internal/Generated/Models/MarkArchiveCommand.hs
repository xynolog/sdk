-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkArchiveCommand (MarkArchiveCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data MarkArchiveCommand = MarkArchiveCommand
  { markArchiveCommandUserId :: Maybe UserId,
    markArchiveCommandResourceId :: ResourceId,
    markArchiveCommandStorageUri :: Maybe Text,
    markArchiveCommandKeepFile :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON MarkArchiveCommand where parseJSON = checked "MarkArchiveCommand" $ withObject "MarkArchiveCommand" (\fields -> MarkArchiveCommand <$> optional fields "_userId" <*> (fields .: "resourceId") <*> optional fields "storageUri" <*> optional fields "keepFile")

instance ToJSON MarkArchiveCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (markArchiveCommandUserId value), [("resourceId", toJSON (markArchiveCommandResourceId value))], optionalPair "storageUri" (markArchiveCommandStorageUri value), optionalPair "keepFile" (markArchiveCommandKeepFile value)]))
