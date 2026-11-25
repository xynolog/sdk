-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ExtractionDeclined (ExtractionDeclined (..), ExtractionDeclinedKind (..), extractionDeclinedKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ExtractionDeclinedReason

data ExtractionDeclined = ExtractionDeclined
  { extractionDeclinedKind :: ExtractionDeclinedKind,
    extractionDeclinedDeclined :: ExtractionDeclinedReason
  }
  deriving (Eq, Show)

instance FromJSON ExtractionDeclined where parseJSON = checked "ExtractionDeclined" $ withObject "ExtractionDeclined" (\fields -> ExtractionDeclined <$> (fields .: "kind") <*> (fields .: "declined"))

instance ToJSON ExtractionDeclined where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (extractionDeclinedKind value))], [("declined", toJSON (extractionDeclinedDeclined value))]]))

data ExtractionDeclinedKind = ExtractionDeclinedKindDeclined deriving (Eq, Show)

instance FromJSON ExtractionDeclinedKind where parseJSON = checked "ExtractionDeclinedKind" $ \value -> if value == String "declined" then pure ExtractionDeclinedKindDeclined else fail "unknown enumeration member"

instance ToJSON ExtractionDeclinedKind where toJSON ExtractionDeclinedKindDeclined = String "declined"

extractionDeclinedKindText :: ExtractionDeclinedKind -> Text
extractionDeclinedKindText ExtractionDeclinedKindDeclined = "declined"
