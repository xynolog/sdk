-- Generated from client/connection-states.json, bus/registry.json and identifiers/kinds.json; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Transport.Facts (connectionTransitions, traceField, userField) where

import Data.Text (Text)
import Xynolog.Types (ConnectionState (..))

connectionTransitions :: ConnectionState -> [ConnectionState]
connectionTransitions ConnectionStateInitial = [ConnectionStateConnecting, ConnectionStateUnauthenticated, ConnectionStateClosed]
connectionTransitions ConnectionStateConnecting = [ConnectionStateOpen, ConnectionStateReconnecting, ConnectionStateUnauthenticated, ConnectionStateClosed]
connectionTransitions ConnectionStateOpen = [ConnectionStateReconnecting, ConnectionStateClosed]
connectionTransitions ConnectionStateReconnecting = [ConnectionStateConnecting, ConnectionStateDegraded, ConnectionStateUnauthenticated, ConnectionStateClosed]
connectionTransitions ConnectionStateDegraded = [ConnectionStateConnecting, ConnectionStateUnauthenticated, ConnectionStateClosed]
connectionTransitions ConnectionStateUnauthenticated = [ConnectionStateConnecting, ConnectionStateClosed]
connectionTransitions ConnectionStateClosed = []

traceField :: Text
traceField = "_trace"

userField :: Text
userField = "_userId"
