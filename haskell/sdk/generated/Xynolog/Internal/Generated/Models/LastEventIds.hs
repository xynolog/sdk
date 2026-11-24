-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LastEventIds (LastEventIds (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.PersistedEventId

data LastEventIds = LastEventIds
  { lastEventIdsAdditionalProperties :: KM.KeyMap PersistedEventId
  }
  deriving (Eq, Show)

instance FromJSON LastEventIds where parseJSON = checked "LastEventIds" $ withObject "LastEventIds" (\fields -> LastEventIds <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON LastEventIds where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (lastEventIdsAdditionalProperties value)))
