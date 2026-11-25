-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.HealthResponse (HealthResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data HealthResponse = HealthResponse
  { healthResponseStatus :: Text,
    healthResponseMessage :: Text,
    healthResponseVersion :: Text,
    healthResponseTimestamp :: Text
  }
  deriving (Eq, Show)

instance FromJSON HealthResponse where parseJSON = checked "HealthResponse" $ withObject "HealthResponse" (\fields -> HealthResponse <$> (fields .: "status") <*> (fields .: "message") <*> (fields .: "version") <*> (fields .: "timestamp"))

instance ToJSON HealthResponse where toJSON value = Object (KM.fromList (concat [[("status", toJSON (healthResponseStatus value))], [("message", toJSON (healthResponseMessage value))], [("version", toJSON (healthResponseVersion value))], [("timestamp", toJSON (healthResponseTimestamp value))]]))
