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
    yieldClonePersistCommandByteSize :: Integer,
    yieldClonePersistCommandContentChecksum :: Text,
    yieldClonePersistCommandEntityTypes :: Maybe [Text],
    yieldClonePersistCommandFormat :: ContentFormat,
    yieldClonePersistCommandLanguage :: Maybe Text,
    yieldClonePersistCommandName :: Text,
    yieldClonePersistCommandParentResourceId :: ResourceId,
    yieldClonePersistCommandStorageUri :: Text
  }
  deriving (Eq, Show)

instance FromJSON YieldClonePersistCommand where parseJSON = checked "YieldClonePersistCommand" $ withObject "YieldClonePersistCommand" (\fields -> YieldClonePersistCommand <$> optional fields "_userId" <*> (fields .: "byteSize") <*> (fields .: "contentChecksum") <*> optional fields "entityTypes" <*> (fields .: "format") <*> optional fields "language" <*> (fields .: "name") <*> (fields .: "parentResourceId") <*> (fields .: "storageUri"))

instance ToJSON YieldClonePersistCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (yieldClonePersistCommandUserId value), [("byteSize", toJSON (yieldClonePersistCommandByteSize value))], [("contentChecksum", toJSON (yieldClonePersistCommandContentChecksum value))], optionalPair "entityTypes" (yieldClonePersistCommandEntityTypes value), [("format", toJSON (yieldClonePersistCommandFormat value))], optionalPair "language" (yieldClonePersistCommandLanguage value), [("name", toJSON (yieldClonePersistCommandName value))], [("parentResourceId", toJSON (yieldClonePersistCommandParentResourceId value))], [("storageUri", toJSON (yieldClonePersistCommandStorageUri value))]]))
