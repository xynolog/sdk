-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BusSubscribeRequest (BusSubscribeRequest (..), BusSubscribeRequestScopedItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data BusSubscribeRequest = BusSubscribeRequest
  { busSubscribeRequestGlobal :: Maybe [Text],
    busSubscribeRequestPendingReplies :: Maybe [Text],
    busSubscribeRequestScoped :: Maybe [BusSubscribeRequestScopedItem],
    busSubscribeRequestClientId :: Text
  }
  deriving (Eq, Show)

instance FromJSON BusSubscribeRequest where parseJSON = checked "BusSubscribeRequest" $ withObject "BusSubscribeRequest" (\fields -> BusSubscribeRequest <$> optional fields "global" <*> optional fields "pendingReplies" <*> optional fields "scoped" <*> (fields .: "clientId"))

instance ToJSON BusSubscribeRequest where toJSON value = Object (KM.fromList (concat [optionalPair "global" (busSubscribeRequestGlobal value), optionalPair "pendingReplies" (busSubscribeRequestPendingReplies value), optionalPair "scoped" (busSubscribeRequestScoped value), [("clientId", toJSON (busSubscribeRequestClientId value))]]))

data BusSubscribeRequestScopedItem = BusSubscribeRequestScopedItem
  { busSubscribeRequestScopedItemScope :: ResourceId,
    busSubscribeRequestScopedItemChannels :: [Text],
    busSubscribeRequestScopedItemLastEventId :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON BusSubscribeRequestScopedItem where parseJSON = checked "BusSubscribeRequestScopedItem" $ withObject "BusSubscribeRequestScopedItem" (\fields -> BusSubscribeRequestScopedItem <$> (fields .: "scope") <*> (fields .: "channels") <*> optional fields "lastEventId")

instance ToJSON BusSubscribeRequestScopedItem where toJSON value = Object (KM.fromList (concat [[("scope", toJSON (busSubscribeRequestScopedItemScope value))], [("channels", toJSON (busSubscribeRequestScopedItemChannels value))], optionalPair "lastEventId" (busSubscribeRequestScopedItemLastEventId value)]))
