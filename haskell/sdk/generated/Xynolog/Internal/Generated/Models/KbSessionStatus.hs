-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbSessionStatus (KbSessionStatus (..), kbSessionStatusText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data KbSessionStatus = KbSessionStatusAuthenticated | KbSessionStatusExpired | KbSessionStatusSignedOut deriving (Eq, Show)

instance FromJSON KbSessionStatus where parseJSON = checked "KbSessionStatus" $ \value -> if value == String "authenticated" then pure KbSessionStatusAuthenticated else if value == String "expired" then pure KbSessionStatusExpired else if value == String "signed-out" then pure KbSessionStatusSignedOut else fail "unknown enumeration member"

instance ToJSON KbSessionStatus where
  toJSON KbSessionStatusAuthenticated = String "authenticated"
  toJSON KbSessionStatusExpired = String "expired"
  toJSON KbSessionStatusSignedOut = String "signed-out"

kbSessionStatusText :: KbSessionStatus -> Text
kbSessionStatusText KbSessionStatusAuthenticated = "authenticated"
kbSessionStatusText KbSessionStatusExpired = "expired"
kbSessionStatusText KbSessionStatusSignedOut = "signed-out"
