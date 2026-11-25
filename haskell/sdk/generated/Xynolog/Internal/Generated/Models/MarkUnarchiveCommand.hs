-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkUnarchiveCommand (MarkUnarchiveCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data MarkUnarchiveCommand = MarkUnarchiveCommand
  { markUnarchiveCommandUserId :: Maybe UserId,
    markUnarchiveCommandResourceId :: ResourceId,
    markUnarchiveCommandStorageUri :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON MarkUnarchiveCommand where parseJSON = checked "MarkUnarchiveCommand" $ withObject "MarkUnarchiveCommand" (\fields -> MarkUnarchiveCommand <$> optional fields "_userId" <*> (fields .: "resourceId") <*> optional fields "storageUri")

instance ToJSON MarkUnarchiveCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (markUnarchiveCommandUserId value), [("resourceId", toJSON (markUnarchiveCommandResourceId value))], optionalPair "storageUri" (markUnarchiveCommandStorageUri value)]))
