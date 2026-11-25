-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GetEventsResponse (GetEventsResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AttributedEvent
import Xynolog.Internal.Generated.Models.ResourceId

data GetEventsResponse = GetEventsResponse
  { getEventsResponseEvents :: [AttributedEvent],
    getEventsResponseResourceId :: ResourceId,
    getEventsResponseTotal :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON GetEventsResponse where parseJSON = checked "GetEventsResponse" $ withObject "GetEventsResponse" (\fields -> GetEventsResponse <$> (fields .: "events") <*> (fields .: "resourceId") <*> (fields .: "total"))

instance ToJSON GetEventsResponse where toJSON value = Object (KM.fromList (concat [[("events", toJSON (getEventsResponseEvents value))], [("resourceId", toJSON (getEventsResponseResourceId value))], [("total", toJSON (getEventsResponseTotal value))]]))
