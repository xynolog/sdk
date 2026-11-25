-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseEventsRequest (BrowseEventsRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data BrowseEventsRequest = BrowseEventsRequest
  { browseEventsRequestLimit :: Maybe Integer,
    browseEventsRequestResourceId :: ResourceId,
    browseEventsRequestType :: Maybe Text,
    browseEventsRequestUserId :: Maybe UserId
  }
  deriving (Eq, Show)

instance FromJSON BrowseEventsRequest where parseJSON = checked "BrowseEventsRequest" $ withObject "BrowseEventsRequest" (\fields -> BrowseEventsRequest <$> optional fields "limit" <*> (fields .: "resourceId") <*> optional fields "type" <*> optional fields "userId")

instance ToJSON BrowseEventsRequest where toJSON value = Object (KM.fromList (concat [optionalPair "limit" (browseEventsRequestLimit value), [("resourceId", toJSON (browseEventsRequestResourceId value))], optionalPair "type" (browseEventsRequestType value), optionalPair "userId" (browseEventsRequestUserId value)]))
