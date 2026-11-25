-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldClonePersistCommand (YieldClonePersistCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ContentFormat
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data YieldClonePersistCommand = YieldClonePersistCommand
  { yieldClonePersistCommandUserId :: Maybe UserId,
    yieldClonePersistCommandName :: Text,
    yieldClonePersistCommandStorageUri :: Text,
    yieldClonePersistCommandContentChecksum :: Text,
    yieldClonePersistCommandByteSize :: Integer,
    yieldClonePersistCommandFormat :: ContentFormat,
    yieldClonePersistCommandLanguage :: Maybe Text,
    yieldClonePersistCommandEntityTypes :: Maybe [Text],
    yieldClonePersistCommandParentResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON YieldClonePersistCommand where parseJSON = checked "YieldClonePersistCommand" $ withObject "YieldClonePersistCommand" (\fields -> YieldClonePersistCommand <$> optional fields "_userId" <*> (fields .: "name") <*> (fields .: "storageUri") <*> (fields .: "contentChecksum") <*> (fields .: "byteSize") <*> (fields .: "format") <*> optional fields "language" <*> optional fields "entityTypes" <*> (fields .: "parentResourceId"))

instance ToJSON YieldClonePersistCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (yieldClonePersistCommandUserId value), [("name", toJSON (yieldClonePersistCommandName value))], [("storageUri", toJSON (yieldClonePersistCommandStorageUri value))], [("contentChecksum", toJSON (yieldClonePersistCommandContentChecksum value))], [("byteSize", toJSON (yieldClonePersistCommandByteSize value))], [("format", toJSON (yieldClonePersistCommandFormat value))], optionalPair "language" (yieldClonePersistCommandLanguage value), optionalPair "entityTypes" (yieldClonePersistCommandEntityTypes value), [("parentResourceId", toJSON (yieldClonePersistCommandParentResourceId value))]]))
