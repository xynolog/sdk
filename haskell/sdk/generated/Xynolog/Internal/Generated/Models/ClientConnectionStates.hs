-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ClientConnectionStates (ClientConnectionStates (..), ClientConnectionStatesStatesItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConnectionState

data ClientConnectionStates = ClientConnectionStates
  { clientConnectionStatesComment :: Text,
    clientConnectionStatesStates :: [ClientConnectionStatesStatesItem]
  }
  deriving (Eq, Show)

instance FromJSON ClientConnectionStates where parseJSON = checked "ClientConnectionStates" $ withObject "ClientConnectionStates" (\fields -> ClientConnectionStates <$> (fields .: "$comment") <*> (fields .: "states"))

instance ToJSON ClientConnectionStates where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (clientConnectionStatesComment value))], [("states", toJSON (clientConnectionStatesStates value))]]))

data ClientConnectionStatesStatesItem = ClientConnectionStatesStatesItem
  { clientConnectionStatesStatesItemState :: ConnectionState,
    clientConnectionStatesStatesItemMeaning :: Text,
    clientConnectionStatesStatesItemMoves :: [ConnectionState]
  }
  deriving (Eq, Show)

instance FromJSON ClientConnectionStatesStatesItem where parseJSON = checked "ClientConnectionStatesStatesItem" $ withObject "ClientConnectionStatesStatesItem" (\fields -> ClientConnectionStatesStatesItem <$> (fields .: "state") <*> (fields .: "meaning") <*> (fields .: "moves"))

instance ToJSON ClientConnectionStatesStatesItem where toJSON value = Object (KM.fromList (concat [[("state", toJSON (clientConnectionStatesStatesItemState value))], [("meaning", toJSON (clientConnectionStatesStatesItemMeaning value))], [("moves", toJSON (clientConnectionStatesStatesItemMoves value))]]))
