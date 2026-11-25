-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceErrorEvent (ResourceErrorEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data ResourceErrorEvent = ResourceErrorEvent
  { resourceErrorEventResourceId :: ResourceId,
    resourceErrorEventMessage :: Text
  }
  deriving (Eq, Show)

instance FromJSON ResourceErrorEvent where parseJSON = checked "ResourceErrorEvent" $ withObject "ResourceErrorEvent" (\fields -> ResourceErrorEvent <$> (fields .: "resourceId") <*> (fields .: "message"))

instance ToJSON ResourceErrorEvent where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (resourceErrorEventResourceId value))], [("message", toJSON (resourceErrorEventMessage value))]]))
