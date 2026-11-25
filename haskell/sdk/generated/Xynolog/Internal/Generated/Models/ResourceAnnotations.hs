-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceAnnotations (ResourceAnnotations (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Annotation
import Xynolog.Internal.Generated.Models.ResourceId

data ResourceAnnotations = ResourceAnnotations
  { resourceAnnotationsResourceId :: ResourceId,
    resourceAnnotationsAnnotations :: [Annotation],
    resourceAnnotationsVersion :: Integer,
    resourceAnnotationsUpdatedAt :: Text
  }
  deriving (Eq, Show)

instance FromJSON ResourceAnnotations where parseJSON = checked "ResourceAnnotations" $ withObject "ResourceAnnotations" (\fields -> ResourceAnnotations <$> (fields .: "resourceId") <*> (fields .: "annotations") <*> (fields .: "version") <*> (fields .: "updatedAt"))

instance ToJSON ResourceAnnotations where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (resourceAnnotationsResourceId value))], [("annotations", toJSON (resourceAnnotationsAnnotations value))], [("version", toJSON (resourceAnnotationsVersion value))], [("updatedAt", toJSON (resourceAnnotationsUpdatedAt value))]]))
