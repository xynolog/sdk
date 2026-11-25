-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceView (ResourceView (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceAnnotations
import Xynolog.Internal.Generated.Models.ResourceDescriptor

data ResourceView = ResourceView
  { resourceViewResource :: ResourceDescriptor,
    resourceViewAnnotations :: ResourceAnnotations,
    resourceViewLastSequence :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ResourceView where parseJSON = checked "ResourceView" $ withObject "ResourceView" (\fields -> ResourceView <$> (fields .: "resource") <*> (fields .: "annotations") <*> (fields .: "lastSequence"))

instance ToJSON ResourceView where toJSON value = Object (KM.fromList (concat [[("resource", toJSON (resourceViewResource value))], [("annotations", toJSON (resourceViewAnnotations value))], [("lastSequence", toJSON (resourceViewLastSequence value))]]))
