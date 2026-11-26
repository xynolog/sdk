-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceRepresentation (ResourceRepresentation (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Binary

data ResourceRepresentation = ResourceRepresentation
  { resourceRepresentationData :: Binary,
    resourceRepresentationContentType :: Text
  }
  deriving (Eq, Show)

instance FromJSON ResourceRepresentation where parseJSON = checked "ResourceRepresentation" $ withObject "ResourceRepresentation" (\fields -> ResourceRepresentation <$> (fields .: "data") <*> (fields .: "contentType"))

instance ToJSON ResourceRepresentation where toJSON value = Object (KM.fromList (concat [[("data", toJSON (resourceRepresentationData value))], [("contentType", toJSON (resourceRepresentationContentType value))]]))
