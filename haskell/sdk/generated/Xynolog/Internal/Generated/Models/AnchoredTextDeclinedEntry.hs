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
  { anchoredTextDeclinedEntryV :: AnchoredTextDeclinedEntryV,
    anchoredTextDeclinedEntryStamp :: Text,
    anchoredTextDeclinedEntryDeclined :: ExtractionDeclinedReason
  }
  deriving (Eq, Show)

instance FromJSON AnchoredTextDeclinedEntry where parseJSON = checked "AnchoredTextDeclinedEntry" $ withObject "AnchoredTextDeclinedEntry" (\fields -> AnchoredTextDeclinedEntry <$> (fields .: "v") <*> (fields .: "stamp") <*> (fields .: "declined"))

instance ToJSON AnchoredTextDeclinedEntry where toJSON value = Object (KM.fromList (concat [[("v", toJSON (anchoredTextDeclinedEntryV value))], [("stamp", toJSON (anchoredTextDeclinedEntryStamp value))], [("declined", toJSON (anchoredTextDeclinedEntryDeclined value))]]))

data AnchoredTextDeclinedEntryV = AnchoredTextDeclinedEntryV3 deriving (Eq, Show)

instance FromJSON AnchoredTextDeclinedEntryV where parseJSON = checked "AnchoredTextDeclinedEntryV" $ \value -> if value == Number (read "3.0") then pure AnchoredTextDeclinedEntryV3 else fail "unknown enumeration member"

instance ToJSON AnchoredTextDeclinedEntryV where toJSON AnchoredTextDeclinedEntryV3 = Number (read "3.0")
