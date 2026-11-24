-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FrameRefusalReason (FrameRefusalReason (..), frameRefusalReasonText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data FrameRefusalReason = FrameRefusalReasonLacks | FrameRefusalReasonMalformed deriving (Eq, Show)

instance FromJSON FrameRefusalReason where parseJSON = checked "FrameRefusalReason" $ \value -> if value == String "lacks" then pure FrameRefusalReasonLacks else if value == String "malformed" then pure FrameRefusalReasonMalformed else fail "unknown enumeration member"

instance ToJSON FrameRefusalReason where
  toJSON FrameRefusalReasonLacks = String "lacks"
  toJSON FrameRefusalReasonMalformed = String "malformed"

frameRefusalReasonText :: FrameRefusalReason -> Text
frameRefusalReasonText FrameRefusalReasonLacks = "lacks"
frameRefusalReasonText FrameRefusalReasonMalformed = "malformed"
