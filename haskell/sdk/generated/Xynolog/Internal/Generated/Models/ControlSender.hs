-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ControlSender (ControlSender (..), controlSenderText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data ControlSender = ControlSenderClient | ControlSenderLauncher deriving (Eq, Show)

instance FromJSON ControlSender where parseJSON = checked "ControlSender" $ \value -> if value == String "client" then pure ControlSenderClient else if value == String "launcher" then pure ControlSenderLauncher else fail "unknown enumeration member"

instance ToJSON ControlSender where
  toJSON ControlSenderClient = String "client"
  toJSON ControlSenderLauncher = String "launcher"

controlSenderText :: ControlSender -> Text
controlSenderText ControlSenderClient = "client"
controlSenderText ControlSenderLauncher = "launcher"
