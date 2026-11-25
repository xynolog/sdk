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
  { sessionJoinedEventConnectionId :: Text,
    sessionJoinedEventParticipant :: UserId
  }
  deriving (Eq, Show)

instance FromJSON SessionJoinedEvent where parseJSON = checked "SessionJoinedEvent" $ withObject "SessionJoinedEvent" (\fields -> SessionJoinedEvent <$> (fields .: "connectionId") <*> (fields .: "participant"))

instance ToJSON SessionJoinedEvent where toJSON value = Object (KM.fromList (concat [[("connectionId", toJSON (sessionJoinedEventConnectionId value))], [("participant", toJSON (sessionJoinedEventParticipant value))]]))
