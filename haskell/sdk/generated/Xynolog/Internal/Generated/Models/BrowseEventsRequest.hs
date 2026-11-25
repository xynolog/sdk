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
  { browseEventsRequestResourceId :: ResourceId,
    browseEventsRequestType :: Maybe Text,
    browseEventsRequestUserId :: Maybe UserId,
    browseEventsRequestLimit :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON BrowseEventsRequest where parseJSON = checked "BrowseEventsRequest" $ withObject "BrowseEventsRequest" (\fields -> BrowseEventsRequest <$> (fields .: "resourceId") <*> optional fields "type" <*> optional fields "userId" <*> optional fields "limit")

instance ToJSON BrowseEventsRequest where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (browseEventsRequestResourceId value))], optionalPair "type" (browseEventsRequestType value), optionalPair "userId" (browseEventsRequestUserId value), optionalPair "limit" (browseEventsRequestLimit value)]))
