-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Metadata (Metadata (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data Metadata = Metadata
  { metadataName :: Text,
    metadataNamespace :: Maybe Text,
    metadataLabels :: Maybe (KM.KeyMap Text),
    metadataAnnotations :: Maybe (KM.KeyMap Text)
  }
  deriving (Eq, Show)

instance FromJSON Metadata where parseJSON = checked "Metadata" $ withObject "Metadata" (\fields -> Metadata <$> (fields .: "name") <*> optional fields "namespace" <*> optional fields "labels" <*> optional fields "annotations")

instance ToJSON Metadata where toJSON value = Object (KM.fromList (concat [[("name", toJSON (metadataName value))], optionalPair "namespace" (metadataNamespace value), optionalPair "labels" (metadataLabels value), optionalPair "annotations" (metadataAnnotations value)]))
