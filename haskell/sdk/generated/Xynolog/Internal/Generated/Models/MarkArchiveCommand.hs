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
    markArchiveCommandKeepFile :: Maybe Bool,
    markArchiveCommandResourceId :: ResourceId,
    markArchiveCommandStorageUri :: Maybe Text,
    markArchiveCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON MarkArchiveCommand where parseJSON = checked "MarkArchiveCommand" $ withObject "MarkArchiveCommand" (\fields -> MarkArchiveCommand <$> optional fields "_userId" <*> optional fields "keepFile" <*> (fields .: "resourceId") <*> optional fields "storageUri" <*> traverse parseJSON (withoutFields ["_userId", "keepFile", "resourceId", "storageUri"] fields))

instance ToJSON MarkArchiveCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (markArchiveCommandUserId value), optionalPair "keepFile" (markArchiveCommandKeepFile value), [("resourceId", toJSON (markArchiveCommandResourceId value))], optionalPair "storageUri" (markArchiveCommandStorageUri value)]) <> fmap toJSON (withoutFields ["_userId", "keepFile", "resourceId", "storageUri"] (markArchiveCommandAdditionalProperties value)))
