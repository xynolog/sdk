-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseResourceViewedEvent (BrowseResourceViewedEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data BrowseResourceViewedEvent = BrowseResourceViewedEvent
  { browseResourceViewedEventResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON BrowseResourceViewedEvent where parseJSON = checked "BrowseResourceViewedEvent" $ withObject "BrowseResourceViewedEvent" (\fields -> BrowseResourceViewedEvent <$> (fields .: "resourceId"))

instance ToJSON BrowseResourceViewedEvent where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (browseResourceViewedEventResourceId value))]]))
