-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchoredTextDeclinedEntry (AnchoredTextDeclinedEntry (..), AnchoredTextDeclinedEntryV (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ExtractionDeclinedReason

data AnchoredTextDeclinedEntry = AnchoredTextDeclinedEntry
  { anchoredTextDeclinedEntryDeclined :: ExtractionDeclinedReason,
    anchoredTextDeclinedEntryStamp :: Text,
    anchoredTextDeclinedEntryV :: AnchoredTextDeclinedEntryV
  }
  deriving (Eq, Show)

instance FromJSON AnchoredTextDeclinedEntry where parseJSON = checked "AnchoredTextDeclinedEntry" $ withObject "AnchoredTextDeclinedEntry" (\fields -> AnchoredTextDeclinedEntry <$> (fields .: "declined") <*> (fields .: "stamp") <*> (fields .: "v"))

instance ToJSON AnchoredTextDeclinedEntry where toJSON value = Object (KM.fromList (concat [[("declined", toJSON (anchoredTextDeclinedEntryDeclined value))], [("stamp", toJSON (anchoredTextDeclinedEntryStamp value))], [("v", toJSON (anchoredTextDeclinedEntryV value))]]))

data AnchoredTextDeclinedEntryV = AnchoredTextDeclinedEntryV3 deriving (Eq, Show)

instance FromJSON AnchoredTextDeclinedEntryV where parseJSON = checked "AnchoredTextDeclinedEntryV" $ \value -> if value == Number (read "3.0") then pure AnchoredTextDeclinedEntryV3 else fail "unknown enumeration member"

instance ToJSON AnchoredTextDeclinedEntryV where toJSON AnchoredTextDeclinedEntryV3 = Number (read "3.0")
