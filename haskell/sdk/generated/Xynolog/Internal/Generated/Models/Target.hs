-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Target (Target (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbPlacement

data Target = Target
  { targetKind :: KbPlacement,
    targetRoot :: Maybe Text,
    targetRepo :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON Target where parseJSON = checked "Target" $ withObject "Target" (\fields -> Target <$> (fields .: "kind") <*> optional fields "root" <*> optional fields "repo")

instance ToJSON Target where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (targetKind value))], optionalPair "root" (targetRoot value), optionalPair "repo" (targetRepo value)]))
