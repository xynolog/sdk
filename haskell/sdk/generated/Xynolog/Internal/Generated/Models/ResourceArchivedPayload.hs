-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceArchivedPayload (ResourceArchivedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ResourceArchivedPayload = ResourceArchivedPayload
  { resourceArchivedPayloadReason :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ResourceArchivedPayload where parseJSON = checked "ResourceArchivedPayload" $ withObject "ResourceArchivedPayload" (\fields -> ResourceArchivedPayload <$> optional fields "reason")

instance ToJSON ResourceArchivedPayload where toJSON value = Object (KM.fromList (concat [optionalPair "reason" (resourceArchivedPayloadReason value)]))
