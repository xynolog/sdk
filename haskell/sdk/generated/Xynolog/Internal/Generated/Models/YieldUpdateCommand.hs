-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldUpdateCommand (YieldUpdateCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data YieldUpdateCommand = YieldUpdateCommand
  { yieldUpdateCommandUserId :: Maybe UserId,
    yieldUpdateCommandByteSize :: Integer,
    yieldUpdateCommandContentChecksum :: Text,
    yieldUpdateCommandResourceId :: ResourceId,
    yieldUpdateCommandStorageUri :: Text,
    yieldUpdateCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON YieldUpdateCommand where parseJSON = checked "YieldUpdateCommand" $ withObject "YieldUpdateCommand" (\fields -> YieldUpdateCommand <$> optional fields "_userId" <*> (fields .: "byteSize") <*> (fields .: "contentChecksum") <*> (fields .: "resourceId") <*> (fields .: "storageUri") <*> traverse parseJSON (withoutFields ["_userId", "byteSize", "contentChecksum", "resourceId", "storageUri"] fields))

instance ToJSON YieldUpdateCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (yieldUpdateCommandUserId value), [("byteSize", toJSON (yieldUpdateCommandByteSize value))], [("contentChecksum", toJSON (yieldUpdateCommandContentChecksum value))], [("resourceId", toJSON (yieldUpdateCommandResourceId value))], [("storageUri", toJSON (yieldUpdateCommandStorageUri value))]]) <> fmap toJSON (withoutFields ["_userId", "byteSize", "contentChecksum", "resourceId", "storageUri"] (yieldUpdateCommandAdditionalProperties value)))
