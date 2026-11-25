-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SessionLeftEvent (SessionLeftEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.UserId

data SessionLeftEvent = SessionLeftEvent
  { sessionLeftEventParticipant :: UserId,
    sessionLeftEventConnectionId :: Text
  }
  deriving (Eq, Show)

instance FromJSON SessionLeftEvent where parseJSON = checked "SessionLeftEvent" $ withObject "SessionLeftEvent" (\fields -> SessionLeftEvent <$> (fields .: "participant") <*> (fields .: "connectionId"))

instance ToJSON SessionLeftEvent where toJSON value = Object (KM.fromList (concat [[("participant", toJSON (sessionLeftEventParticipant value))], [("connectionId", toJSON (sessionLeftEventConnectionId value))]]))
