-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseRouterPushEvent (BrowseRouterPushEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data BrowseRouterPushEvent = BrowseRouterPushEvent
  { browseRouterPushEventPath :: Text,
    browseRouterPushEventReason :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON BrowseRouterPushEvent where parseJSON = checked "BrowseRouterPushEvent" $ withObject "BrowseRouterPushEvent" (\fields -> BrowseRouterPushEvent <$> (fields .: "path") <*> optional fields "reason")

instance ToJSON BrowseRouterPushEvent where toJSON value = Object (KM.fromList (concat [[("path", toJSON (browseRouterPushEventPath value))], optionalPair "reason" (browseRouterPushEventReason value)]))
