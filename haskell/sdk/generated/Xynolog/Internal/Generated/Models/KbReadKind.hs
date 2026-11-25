-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbReadKind (KbReadKind (..), kbReadKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data KbReadKind = KbReadKindRecorded | KbReadKindConflict | KbReadKindNoVerdict deriving (Eq, Show)

instance FromJSON KbReadKind where parseJSON = checked "KbReadKind" $ \value -> if value == String "recorded" then pure KbReadKindRecorded else if value == String "conflict" then pure KbReadKindConflict else if value == String "no-verdict" then pure KbReadKindNoVerdict else fail "unknown enumeration member"

instance ToJSON KbReadKind where
  toJSON KbReadKindRecorded = String "recorded"
  toJSON KbReadKindConflict = String "conflict"
  toJSON KbReadKindNoVerdict = String "no-verdict"

kbReadKindText :: KbReadKind -> Text
kbReadKindText KbReadKindRecorded = "recorded"
kbReadKindText KbReadKindConflict = "conflict"
kbReadKindText KbReadKindNoVerdict = "no-verdict"
