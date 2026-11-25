-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseResourcesRequest (BrowseResourcesRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data BrowseResourcesRequest = BrowseResourcesRequest
  { browseResourcesRequestArchived :: Maybe Bool,
    browseResourcesRequestEntityType :: Maybe Text,
    browseResourcesRequestOffset :: Maybe Integer,
    browseResourcesRequestLimit :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON BrowseResourcesRequest where parseJSON = checked "BrowseResourcesRequest" $ withObject "BrowseResourcesRequest" (\fields -> BrowseResourcesRequest <$> optional fields "archived" <*> optional fields "entityType" <*> optional fields "offset" <*> optional fields "limit")

instance ToJSON BrowseResourcesRequest where toJSON value = Object (KM.fromList (concat [optionalPair "archived" (browseResourcesRequestArchived value), optionalPair "entityType" (browseResourcesRequestEntityType value), optionalPair "offset" (browseResourcesRequestOffset value), optionalPair "limit" (browseResourcesRequestLimit value)]))
