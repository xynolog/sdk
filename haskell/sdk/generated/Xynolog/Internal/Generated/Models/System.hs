-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.System (System (..), systemText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data System = SystemMacos | SystemWindows | SystemOther deriving (Eq, Show)

instance FromJSON System where parseJSON = checked "System" $ \value -> if value == String "macos" then pure SystemMacos else if value == String "windows" then pure SystemWindows else if value == String "other" then pure SystemOther else fail "unknown enumeration member"

instance ToJSON System where
  toJSON SystemMacos = String "macos"
  toJSON SystemWindows = String "windows"
  toJSON SystemOther = String "other"

systemText :: System -> Text
systemText SystemMacos = "macos"
systemText SystemWindows = "windows"
systemText SystemOther = "other"
