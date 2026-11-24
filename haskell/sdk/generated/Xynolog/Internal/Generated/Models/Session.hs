-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Session (Session (..), SessionState (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data Session = Session
  { sessionEmail :: Maybe Text,
    sessionState :: SessionState
  }
  deriving (Eq, Show)

instance FromJSON Session where parseJSON = checked "Session" $ withObject "Session" (\fields -> Session <$> optional fields "email" <*> (fields .: "state"))

instance ToJSON Session where toJSON value = Object (KM.fromList (concat [optionalPair "email" (sessionEmail value), [("state", toJSON (sessionState value))]]))

data SessionState = SessionStateValid | SessionStateExpired | SessionStateUnverified | SessionStateNone deriving (Eq, Show)

instance FromJSON SessionState where parseJSON = checked "SessionState" $ \value -> if value == String "valid" then pure SessionStateValid else if value == String "expired" then pure SessionStateExpired else if value == String "unverified" then pure SessionStateUnverified else if value == String "none" then pure SessionStateNone else fail "unknown enumeration member"

instance ToJSON SessionState where
  toJSON SessionStateValid = String "valid"
  toJSON SessionStateExpired = String "expired"
  toJSON SessionStateUnverified = String "unverified"
  toJSON SessionStateNone = String "none"
