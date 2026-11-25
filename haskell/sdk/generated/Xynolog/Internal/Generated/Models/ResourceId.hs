-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceId (ResourceId, resourceIdValue, mkResourceId) where

import Data.Aeson (FromJSON (..), FromJSONKey (..), FromJSONKeyFunction (..), ToJSON (..), ToJSONKey (..), Value (..))
import Data.Aeson.Types (parseEither, toJSONKeyText)
import Data.Text (Text)
import Xynolog.Internal.Codec

newtype ResourceId = ResourceId Text deriving (Eq, Ord, Show)

instance FromJSON ResourceId where parseJSON = checked "ResourceId" $ \value -> ResourceId <$> parseJSON value

instance ToJSON ResourceId where toJSON (ResourceId value) = toJSON value

instance FromJSONKey ResourceId where fromJSONKey = FromJSONKeyTextParser (parseJSON . String)

instance ToJSONKey ResourceId where toJSONKey = toJSONKeyText resourceIdValue

resourceIdValue :: ResourceId -> Text
resourceIdValue (ResourceId value) = value

mkResourceId :: Text -> Either String ResourceId
mkResourceId value = parseEither parseJSON (toJSON value)
