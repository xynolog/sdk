-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldCloneCreateCommand (YieldCloneCreateCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ContentFormat
import Xynolog.Internal.Generated.Models.UserId

data YieldCloneCreateCommand = YieldCloneCreateCommand
  { yieldCloneCreateCommandUserId :: Maybe UserId,
    yieldCloneCreateCommandToken :: Text,
    yieldCloneCreateCommandName :: Text,
    yieldCloneCreateCommandStorageUri :: Text,
    yieldCloneCreateCommandContentChecksum :: Text,
    yieldCloneCreateCommandByteSize :: Integer,
    yieldCloneCreateCommandFormat :: ContentFormat,
    yieldCloneCreateCommandArchiveOriginal :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON YieldCloneCreateCommand where parseJSON = checked "YieldCloneCreateCommand" $ withObject "YieldCloneCreateCommand" (\fields -> YieldCloneCreateCommand <$> optional fields "_userId" <*> (fields .: "token") <*> (fields .: "name") <*> (fields .: "storageUri") <*> (fields .: "contentChecksum") <*> (fields .: "byteSize") <*> (fields .: "format") <*> optional fields "archiveOriginal")

instance ToJSON YieldCloneCreateCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (yieldCloneCreateCommandUserId value), [("token", toJSON (yieldCloneCreateCommandToken value))], [("name", toJSON (yieldCloneCreateCommandName value))], [("storageUri", toJSON (yieldCloneCreateCommandStorageUri value))], [("contentChecksum", toJSON (yieldCloneCreateCommandContentChecksum value))], [("byteSize", toJSON (yieldCloneCreateCommandByteSize value))], [("format", toJSON (yieldCloneCreateCommandFormat value))], optionalPair "archiveOriginal" (yieldCloneCreateCommandArchiveOriginal value)]))
