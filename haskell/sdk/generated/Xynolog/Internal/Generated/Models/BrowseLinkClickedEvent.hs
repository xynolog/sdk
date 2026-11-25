-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseLinkClickedEvent (BrowseLinkClickedEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data BrowseLinkClickedEvent = BrowseLinkClickedEvent
  { browseLinkClickedEventHref :: Text,
    browseLinkClickedEventLabel :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON BrowseLinkClickedEvent where parseJSON = checked "BrowseLinkClickedEvent" $ withObject "BrowseLinkClickedEvent" (\fields -> BrowseLinkClickedEvent <$> (fields .: "href") <*> optional fields "label")

instance ToJSON BrowseLinkClickedEvent where toJSON value = Object (KM.fromList (concat [[("href", toJSON (browseLinkClickedEventHref value))], optionalPair "label" (browseLinkClickedEventLabel value)]))
