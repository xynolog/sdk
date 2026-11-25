-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseEntityTypeClickedEvent (BrowseEntityTypeClickedEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data BrowseEntityTypeClickedEvent = BrowseEntityTypeClickedEvent
  { browseEntityTypeClickedEventEntityType :: Text
  }
  deriving (Eq, Show)

instance FromJSON BrowseEntityTypeClickedEvent where parseJSON = checked "BrowseEntityTypeClickedEvent" $ withObject "BrowseEntityTypeClickedEvent" (\fields -> BrowseEntityTypeClickedEvent <$> (fields .: "entityType"))

instance ToJSON BrowseEntityTypeClickedEvent where toJSON value = Object (KM.fromList (concat [[("entityType", toJSON (browseEntityTypeClickedEventEntityType value))]]))
