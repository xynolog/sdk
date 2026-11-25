-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseResourceOpenEvent (BrowseResourceOpenEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data BrowseResourceOpenEvent = BrowseResourceOpenEvent
  { browseResourceOpenEventResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON BrowseResourceOpenEvent where parseJSON = checked "BrowseResourceOpenEvent" $ withObject "BrowseResourceOpenEvent" (\fields -> BrowseResourceOpenEvent <$> (fields .: "resourceId"))

instance ToJSON BrowseResourceOpenEvent where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (browseResourceOpenEventResourceId value))]]))
