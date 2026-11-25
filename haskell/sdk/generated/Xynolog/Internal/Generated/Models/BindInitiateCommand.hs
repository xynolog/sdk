-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BindInitiateCommand (BindInitiateCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ResourceId

data BindInitiateCommand = BindInitiateCommand
  { bindInitiateCommandAnnotationId :: AnnotationId,
    bindInitiateCommandDefaultTitle :: Text,
    bindInitiateCommandEntityTypes :: [Text],
    bindInitiateCommandResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON BindInitiateCommand where parseJSON = checked "BindInitiateCommand" $ withObject "BindInitiateCommand" (\fields -> BindInitiateCommand <$> (fields .: "annotationId") <*> (fields .: "defaultTitle") <*> (fields .: "entityTypes") <*> (fields .: "resourceId"))

instance ToJSON BindInitiateCommand where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (bindInitiateCommandAnnotationId value))], [("defaultTitle", toJSON (bindInitiateCommandDefaultTitle value))], [("entityTypes", toJSON (bindInitiateCommandEntityTypes value))], [("resourceId", toJSON (bindInitiateCommandResourceId value))]]))
