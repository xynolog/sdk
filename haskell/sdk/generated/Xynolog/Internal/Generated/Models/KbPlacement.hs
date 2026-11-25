-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbPlacement (KbPlacement (..), kbPlacementText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data KbPlacement = KbPlacementLocal | KbPlacementCodespace deriving (Eq, Show)

instance FromJSON KbPlacement where parseJSON = checked "KbPlacement" $ \value -> if value == String "local" then pure KbPlacementLocal else if value == String "codespace" then pure KbPlacementCodespace else fail "unknown enumeration member"

instance ToJSON KbPlacement where
  toJSON KbPlacementLocal = String "local"
  toJSON KbPlacementCodespace = String "codespace"

kbPlacementText :: KbPlacement -> Text
kbPlacementText KbPlacementLocal = "local"
kbPlacementText KbPlacementCodespace = "codespace"
