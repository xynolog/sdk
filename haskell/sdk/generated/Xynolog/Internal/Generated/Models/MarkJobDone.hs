-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkJobDone (MarkJobDone (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data MarkJobDone = MarkJobDone
  { markJobDoneFound :: Integer,
    markJobDonePersisted :: Integer,
    markJobDoneErrors :: Maybe Integer,
    markJobDoneByCategory :: Maybe (KM.KeyMap Integer),
    markJobDoneUnderReportedPieces :: Maybe Integer,
    markJobDoneUncheckedPieces :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON MarkJobDone where parseJSON = checked "MarkJobDone" $ withObject "MarkJobDone" (\fields -> MarkJobDone <$> (fields .: "found") <*> (fields .: "persisted") <*> optional fields "errors" <*> optional fields "byCategory" <*> optional fields "underReportedPieces" <*> optional fields "uncheckedPieces")

instance ToJSON MarkJobDone where toJSON value = Object (KM.fromList (concat [[("found", toJSON (markJobDoneFound value))], [("persisted", toJSON (markJobDonePersisted value))], optionalPair "errors" (markJobDoneErrors value), optionalPair "byCategory" (markJobDoneByCategory value), optionalPair "underReportedPieces" (markJobDoneUnderReportedPieces value), optionalPair "uncheckedPieces" (markJobDoneUncheckedPieces value)]))
