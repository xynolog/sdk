-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SessionJoinedEvent (SessionJoinedEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.UserId

data SessionJoinedEvent = SessionJoinedEvent
  { sessionJoinedEventParticipant :: UserId,
    sessionJoinedEventConnectionId :: Text
  }
  deriving (Eq, Show)

instance FromJSON SessionJoinedEvent where parseJSON = checked "SessionJoinedEvent" $ withObject "SessionJoinedEvent" (\fields -> SessionJoinedEvent <$> (fields .: "participant") <*> (fields .: "connectionId"))

instance ToJSON SessionJoinedEvent where toJSON value = Object (KM.fromList (concat [[("participant", toJSON (sessionJoinedEventParticipant value))], [("connectionId", toJSON (sessionJoinedEventConnectionId value))]]))
