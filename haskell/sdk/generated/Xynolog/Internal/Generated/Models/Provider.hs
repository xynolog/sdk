-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Provider (Provider (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.SecretRef

data Provider = Provider
  { providerApiKey :: Maybe SecretRef,
    providerBaseURL :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON Provider where parseJSON = checked "Provider" $ withObject "Provider" (\fields -> Provider <$> optional fields "apiKey" <*> optional fields "baseURL")

instance ToJSON Provider where toJSON value = Object (KM.fromList (concat [optionalPair "apiKey" (providerApiKey value), optionalPair "baseURL" (providerBaseURL value)]))
