-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseExternalNavigateEvent (BrowseExternalNavigateEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data BrowseExternalNavigateEvent = BrowseExternalNavigateEvent
  { browseExternalNavigateEventUrl :: Text,
    browseExternalNavigateEventResourceId :: Maybe ResourceId
  }
  deriving (Eq, Show)

instance FromJSON BrowseExternalNavigateEvent where parseJSON = checked "BrowseExternalNavigateEvent" $ withObject "BrowseExternalNavigateEvent" (\fields -> BrowseExternalNavigateEvent <$> (fields .: "url") <*> optional fields "resourceId")

instance ToJSON BrowseExternalNavigateEvent where toJSON value = Object (KM.fromList (concat [[("url", toJSON (browseExternalNavigateEventUrl value))], optionalPair "resourceId" (browseExternalNavigateEventResourceId value)]))
