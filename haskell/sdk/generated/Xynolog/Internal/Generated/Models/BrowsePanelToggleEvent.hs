-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowsePanelToggleEvent (BrowsePanelToggleEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data BrowsePanelToggleEvent = BrowsePanelToggleEvent
  { browsePanelToggleEventPanel :: Text
  }
  deriving (Eq, Show)

instance FromJSON BrowsePanelToggleEvent where parseJSON = checked "BrowsePanelToggleEvent" $ withObject "BrowsePanelToggleEvent" (\fields -> BrowsePanelToggleEvent <$> (fields .: "panel"))

instance ToJSON BrowsePanelToggleEvent where toJSON value = Object (KM.fromList (concat [[("panel", toJSON (browsePanelToggleEventPanel value))]]))
