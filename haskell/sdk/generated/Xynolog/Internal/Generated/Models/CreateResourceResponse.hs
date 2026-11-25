-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.CreateResourceResponse (CreateResourceResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data CreateResourceResponse = CreateResourceResponse
  { createResourceResponseResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON CreateResourceResponse where parseJSON = checked "CreateResourceResponse" $ withObject "CreateResourceResponse" (\fields -> CreateResourceResponse <$> (fields .: "resourceId"))

instance ToJSON CreateResourceResponse where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (createResourceResponseResourceId value))]]))
