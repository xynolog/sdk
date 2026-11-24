-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SessionEndReason (SessionEndReason (..), sessionEndReasonText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data SessionEndReason = SessionEndReasonExpired | SessionEndReasonRefused deriving (Eq, Show)

instance FromJSON SessionEndReason where parseJSON = checked "SessionEndReason" $ \value -> if value == String "expired" then pure SessionEndReasonExpired else if value == String "refused" then pure SessionEndReasonRefused else fail "unknown enumeration member"

instance ToJSON SessionEndReason where
  toJSON SessionEndReasonExpired = String "expired"
  toJSON SessionEndReasonRefused = String "refused"

sessionEndReasonText :: SessionEndReason -> Text
sessionEndReasonText SessionEndReasonExpired = "expired"
sessionEndReasonText SessionEndReasonRefused = "refused"
