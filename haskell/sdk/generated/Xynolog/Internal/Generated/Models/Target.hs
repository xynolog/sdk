-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Target (Target (..), TargetKind (..), targetKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data Target = Target
  { targetKind :: TargetKind,
    targetRepo :: Maybe Text,
    targetRoot :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON Target where parseJSON = checked "Target" $ withObject "Target" (\fields -> Target <$> (fields .: "kind") <*> optional fields "repo" <*> optional fields "root")

instance ToJSON Target where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (targetKind value))], optionalPair "repo" (targetRepo value), optionalPair "root" (targetRoot value)]))

data TargetKind = TargetKindLocal | TargetKindCodespace deriving (Eq, Show)

instance FromJSON TargetKind where parseJSON = checked "TargetKind" $ \value -> if value == String "local" then pure TargetKindLocal else if value == String "codespace" then pure TargetKindCodespace else fail "unknown enumeration member"

instance ToJSON TargetKind where
  toJSON TargetKindLocal = String "local"
  toJSON TargetKindCodespace = String "codespace"

targetKindText :: TargetKind -> Text
targetKindText TargetKindLocal = "local"
targetKindText TargetKindCodespace = "codespace"
