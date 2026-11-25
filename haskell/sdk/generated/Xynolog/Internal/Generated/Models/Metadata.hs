-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Metadata (Metadata (..), MetadataAnnotations (..), MetadataLabels (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data Metadata = Metadata
  { metadataName :: Text,
    metadataNamespace :: Maybe Text,
    metadataLabels :: Maybe MetadataLabels,
    metadataAnnotations :: Maybe MetadataAnnotations
  }
  deriving (Eq, Show)

instance FromJSON Metadata where parseJSON = checked "Metadata" $ withObject "Metadata" (\fields -> Metadata <$> (fields .: "name") <*> optional fields "namespace" <*> optional fields "labels" <*> optional fields "annotations")

instance ToJSON Metadata where toJSON value = Object (KM.fromList (concat [[("name", toJSON (metadataName value))], optionalPair "namespace" (metadataNamespace value), optionalPair "labels" (metadataLabels value), optionalPair "annotations" (metadataAnnotations value)]))

data MetadataAnnotations = MetadataAnnotations
  { metadataAnnotationsAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON MetadataAnnotations where parseJSON = checked "MetadataAnnotations" $ withObject "MetadataAnnotations" (\fields -> MetadataAnnotations <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON MetadataAnnotations where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (metadataAnnotationsAdditionalProperties value)))

data MetadataLabels = MetadataLabels
  { metadataLabelsAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON MetadataLabels where parseJSON = checked "MetadataLabels" $ withObject "MetadataLabels" (\fields -> MetadataLabels <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON MetadataLabels where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (metadataLabelsAdditionalProperties value)))
