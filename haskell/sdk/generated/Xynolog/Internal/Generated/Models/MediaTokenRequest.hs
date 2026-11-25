-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MediaTokenRequest (MediaTokenRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data MediaTokenRequest = MediaTokenRequest
  { mediaTokenRequestResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON MediaTokenRequest where parseJSON = checked "MediaTokenRequest" $ withObject "MediaTokenRequest" (\fields -> MediaTokenRequest <$> (fields .: "resourceId"))

instance ToJSON MediaTokenRequest where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (mediaTokenRequestResourceId value))]]))
