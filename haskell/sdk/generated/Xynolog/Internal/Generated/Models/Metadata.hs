-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Metadata (Metadata (..), MetadataAnnotations (..), MetadataLabels (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data Metadata = Metadata
  { metadataAnnotations :: Maybe MetadataAnnotations,
    metadataLabels :: Maybe MetadataLabels,
    metadataName :: Text,
    metadataNamespace :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON Metadata where parseJSON = checked "Metadata" $ withObject "Metadata" (\fields -> Metadata <$> optional fields "annotations" <*> optional fields "labels" <*> (fields .: "name") <*> optional fields "namespace")

instance ToJSON Metadata where toJSON value = Object (KM.fromList (concat [optionalPair "annotations" (metadataAnnotations value), optionalPair "labels" (metadataLabels value), [("name", toJSON (metadataName value))], optionalPair "namespace" (metadataNamespace value)]))

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
