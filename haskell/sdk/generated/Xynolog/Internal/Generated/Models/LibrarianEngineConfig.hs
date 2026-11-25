-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LibrarianEngineConfig (LibrarianEngineConfig (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Engine

data LibrarianEngineConfig = LibrarianEngineConfig
  { librarianEngineConfigEngine :: Engine,
    librarianEngineConfigBaseUrl :: Text,
    librarianEngineConfigApiKeyEnv :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON LibrarianEngineConfig where parseJSON = checked "LibrarianEngineConfig" $ withObject "LibrarianEngineConfig" (\fields -> LibrarianEngineConfig <$> (fields .: "engine") <*> (fields .: "baseUrl") <*> optional fields "apiKeyEnv")

instance ToJSON LibrarianEngineConfig where toJSON value = Object (KM.fromList (concat [[("engine", toJSON (librarianEngineConfigEngine value))], [("baseUrl", toJSON (librarianEngineConfigBaseUrl value))], optionalPair "apiKeyEnv" (librarianEngineConfigApiKeyEnv value)]))
