-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceMovedPayload (ResourceMovedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ResourceMovedPayload = ResourceMovedPayload
  { resourceMovedPayloadFromUri :: Text,
    resourceMovedPayloadToUri :: Text
  }
  deriving (Eq, Show)

instance FromJSON ResourceMovedPayload where parseJSON = checked "ResourceMovedPayload" $ withObject "ResourceMovedPayload" (\fields -> ResourceMovedPayload <$> (fields .: "fromUri") <*> (fields .: "toUri"))

instance ToJSON ResourceMovedPayload where toJSON value = Object (KM.fromList (concat [[("fromUri", toJSON (resourceMovedPayloadFromUri value))], [("toUri", toJSON (resourceMovedPayloadToUri value))]]))
