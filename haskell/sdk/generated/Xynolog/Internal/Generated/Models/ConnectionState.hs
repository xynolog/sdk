-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConnectionState (ConnectionState (..), connectionStateText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data ConnectionState = ConnectionStateInitial | ConnectionStateConnecting | ConnectionStateOpen | ConnectionStateReconnecting | ConnectionStateDegraded | ConnectionStateUnauthenticated | ConnectionStateClosed deriving (Eq, Show)

instance FromJSON ConnectionState where parseJSON = checked "ConnectionState" $ \value -> if value == String "initial" then pure ConnectionStateInitial else if value == String "connecting" then pure ConnectionStateConnecting else if value == String "open" then pure ConnectionStateOpen else if value == String "reconnecting" then pure ConnectionStateReconnecting else if value == String "degraded" then pure ConnectionStateDegraded else if value == String "unauthenticated" then pure ConnectionStateUnauthenticated else if value == String "closed" then pure ConnectionStateClosed else fail "unknown enumeration member"

instance ToJSON ConnectionState where
  toJSON ConnectionStateInitial = String "initial"
  toJSON ConnectionStateConnecting = String "connecting"
  toJSON ConnectionStateOpen = String "open"
  toJSON ConnectionStateReconnecting = String "reconnecting"
  toJSON ConnectionStateDegraded = String "degraded"
  toJSON ConnectionStateUnauthenticated = String "unauthenticated"
  toJSON ConnectionStateClosed = String "closed"

connectionStateText :: ConnectionState -> Text
connectionStateText ConnectionStateInitial = "initial"
connectionStateText ConnectionStateConnecting = "connecting"
connectionStateText ConnectionStateOpen = "open"
connectionStateText ConnectionStateReconnecting = "reconnecting"
connectionStateText ConnectionStateDegraded = "degraded"
connectionStateText ConnectionStateUnauthenticated = "unauthenticated"
connectionStateText ConnectionStateClosed = "closed"
