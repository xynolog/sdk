-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseResourceReorderEvent (BrowseResourceReorderEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data BrowseResourceReorderEvent = BrowseResourceReorderEvent
  { browseResourceReorderEventOldIndex :: Integer,
    browseResourceReorderEventNewIndex :: Integer
  }
  deriving (Eq, Show)

instance FromJSON BrowseResourceReorderEvent where parseJSON = checked "BrowseResourceReorderEvent" $ withObject "BrowseResourceReorderEvent" (\fields -> BrowseResourceReorderEvent <$> (fields .: "oldIndex") <*> (fields .: "newIndex"))

instance ToJSON BrowseResourceReorderEvent where toJSON value = Object (KM.fromList (concat [[("oldIndex", toJSON (browseResourceReorderEventOldIndex value))], [("newIndex", toJSON (browseResourceReorderEventNewIndex value))]]))
