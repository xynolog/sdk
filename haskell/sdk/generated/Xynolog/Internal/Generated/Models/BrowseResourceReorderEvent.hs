-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseResourceReorderEvent (BrowseResourceReorderEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data BrowseResourceReorderEvent = BrowseResourceReorderEvent
  { browseResourceReorderEventNewIndex :: Integer,
    browseResourceReorderEventOldIndex :: Integer
  }
  deriving (Eq, Show)

instance FromJSON BrowseResourceReorderEvent where parseJSON = checked "BrowseResourceReorderEvent" $ withObject "BrowseResourceReorderEvent" (\fields -> BrowseResourceReorderEvent <$> (fields .: "newIndex") <*> (fields .: "oldIndex"))

instance ToJSON BrowseResourceReorderEvent where toJSON value = Object (KM.fromList (concat [[("newIndex", toJSON (browseResourceReorderEventNewIndex value))], [("oldIndex", toJSON (browseResourceReorderEventOldIndex value))]]))
