-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TabVerdict (TabVerdict (..), tabVerdictText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data TabVerdict = TabVerdictGone | TabVerdictReady | TabVerdictUnknown deriving (Eq, Show)

instance FromJSON TabVerdict where parseJSON = checked "TabVerdict" $ \value -> if value == String "gone" then pure TabVerdictGone else if value == String "ready" then pure TabVerdictReady else if value == String "unknown" then pure TabVerdictUnknown else fail "unknown enumeration member"

instance ToJSON TabVerdict where
  toJSON TabVerdictGone = String "gone"
  toJSON TabVerdictReady = String "ready"
  toJSON TabVerdictUnknown = String "unknown"

tabVerdictText :: TabVerdict -> Text
tabVerdictText TabVerdictGone = "gone"
tabVerdictText TabVerdictReady = "ready"
tabVerdictText TabVerdictUnknown = "unknown"
