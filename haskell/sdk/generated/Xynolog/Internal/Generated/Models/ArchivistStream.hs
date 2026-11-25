-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistStream (ArchivistStream (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data ArchivistStream = ArchivistStream
  { archivistStreamResourceId :: ResourceId,
    archivistStreamLastSequence :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ArchivistStream where parseJSON = checked "ArchivistStream" $ withObject "ArchivistStream" (\fields -> ArchivistStream <$> (fields .: "resourceId") <*> (fields .: "lastSequence"))

instance ToJSON ArchivistStream where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (archivistStreamResourceId value))], [("lastSequence", toJSON (archivistStreamLastSequence value))]]))
