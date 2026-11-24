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
  { extractionDeclinedDeclined :: ExtractionDeclinedReason,
    extractionDeclinedKind :: ExtractionDeclinedKind,
    extractionDeclinedAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ExtractionDeclined where parseJSON = checked "ExtractionDeclined" $ withObject "ExtractionDeclined" (\fields -> ExtractionDeclined <$> (fields .: "declined") <*> (fields .: "kind") <*> traverse parseJSON (withoutFields ["declined", "kind"] fields))

instance ToJSON ExtractionDeclined where toJSON value = Object (KM.fromList (concat [[("declined", toJSON (extractionDeclinedDeclined value))], [("kind", toJSON (extractionDeclinedKind value))]]) <> fmap toJSON (withoutFields ["declined", "kind"] (extractionDeclinedAdditionalProperties value)))

data ExtractionDeclinedKind = ExtractionDeclinedKindDeclined deriving (Eq, Show)

instance FromJSON ExtractionDeclinedKind where parseJSON = checked "ExtractionDeclinedKind" $ \value -> if value == String "declined" then pure ExtractionDeclinedKindDeclined else fail "unknown enumeration member"

instance ToJSON ExtractionDeclinedKind where toJSON ExtractionDeclinedKindDeclined = String "declined"

extractionDeclinedKindText :: ExtractionDeclinedKind -> Text
extractionDeclinedKindText ExtractionDeclinedKindDeclined = "declined"
