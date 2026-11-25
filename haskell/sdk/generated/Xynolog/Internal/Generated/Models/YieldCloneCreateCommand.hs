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
    yieldCloneCreateCommandArchiveOriginal :: Maybe Bool,
    yieldCloneCreateCommandByteSize :: Integer,
    yieldCloneCreateCommandContentChecksum :: Text,
    yieldCloneCreateCommandFormat :: ContentFormat,
    yieldCloneCreateCommandName :: Text,
    yieldCloneCreateCommandStorageUri :: Text,
    yieldCloneCreateCommandToken :: Text
  }
  deriving (Eq, Show)

instance FromJSON YieldCloneCreateCommand where parseJSON = checked "YieldCloneCreateCommand" $ withObject "YieldCloneCreateCommand" (\fields -> YieldCloneCreateCommand <$> optional fields "_userId" <*> optional fields "archiveOriginal" <*> (fields .: "byteSize") <*> (fields .: "contentChecksum") <*> (fields .: "format") <*> (fields .: "name") <*> (fields .: "storageUri") <*> (fields .: "token"))

instance ToJSON YieldCloneCreateCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (yieldCloneCreateCommandUserId value), optionalPair "archiveOriginal" (yieldCloneCreateCommandArchiveOriginal value), [("byteSize", toJSON (yieldCloneCreateCommandByteSize value))], [("contentChecksum", toJSON (yieldCloneCreateCommandContentChecksum value))], [("format", toJSON (yieldCloneCreateCommandFormat value))], [("name", toJSON (yieldCloneCreateCommandName value))], [("storageUri", toJSON (yieldCloneCreateCommandStorageUri value))], [("token", toJSON (yieldCloneCreateCommandToken value))]]))
