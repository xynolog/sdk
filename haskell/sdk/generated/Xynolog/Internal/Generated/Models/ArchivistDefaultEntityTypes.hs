-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistDefaultEntityTypes (ArchivistDefaultEntityTypes (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ArchivistDefaultEntityTypes = ArchivistDefaultEntityTypes
  { archivistDefaultEntityTypesComment :: Text,
    archivistDefaultEntityTypesEntityTypes :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON ArchivistDefaultEntityTypes where parseJSON = checked "ArchivistDefaultEntityTypes" $ withObject "ArchivistDefaultEntityTypes" (\fields -> ArchivistDefaultEntityTypes <$> (fields .: "$comment") <*> (fields .: "entityTypes"))

instance ToJSON ArchivistDefaultEntityTypes where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (archivistDefaultEntityTypesComment value))], [("entityTypes", toJSON (archivistDefaultEntityTypesEntityTypes value))]]))
