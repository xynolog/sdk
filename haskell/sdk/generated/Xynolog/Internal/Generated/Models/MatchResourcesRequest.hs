-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MatchResourcesRequest (MatchResourcesRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data MatchResourcesRequest = MatchResourcesRequest
  { matchResourcesRequestSearch :: Text,
    matchResourcesRequestArchived :: Maybe Bool,
    matchResourcesRequestEntityType :: Maybe Text,
    matchResourcesRequestOffset :: Maybe Integer,
    matchResourcesRequestLimit :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON MatchResourcesRequest where parseJSON = checked "MatchResourcesRequest" $ withObject "MatchResourcesRequest" (\fields -> MatchResourcesRequest <$> (fields .: "search") <*> optional fields "archived" <*> optional fields "entityType" <*> optional fields "offset" <*> optional fields "limit")

instance ToJSON MatchResourcesRequest where toJSON value = Object (KM.fromList (concat [[("search", toJSON (matchResourcesRequestSearch value))], optionalPair "archived" (matchResourcesRequestArchived value), optionalPair "entityType" (matchResourcesRequestEntityType value), optionalPair "offset" (matchResourcesRequestOffset value), optionalPair "limit" (matchResourcesRequestLimit value)]))
