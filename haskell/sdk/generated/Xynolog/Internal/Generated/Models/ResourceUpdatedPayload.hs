-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceUpdatedPayload (ResourceUpdatedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ResourceUpdatedPayload = ResourceUpdatedPayload
  { resourceUpdatedPayloadContentChecksum :: Text,
    resourceUpdatedPayloadContentByteSize :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON ResourceUpdatedPayload where parseJSON = checked "ResourceUpdatedPayload" $ withObject "ResourceUpdatedPayload" (\fields -> ResourceUpdatedPayload <$> (fields .: "contentChecksum") <*> optional fields "contentByteSize")

instance ToJSON ResourceUpdatedPayload where toJSON value = Object (KM.fromList (concat [[("contentChecksum", toJSON (resourceUpdatedPayloadContentChecksum value))], optionalPair "contentByteSize" (resourceUpdatedPayloadContentByteSize value)]))
