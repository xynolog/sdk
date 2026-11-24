-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SettingsPathParams (SettingsPathParams (..), SettingsPathParamsDocument (..), settingsPathParamsDocumentText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion

data SettingsPathParams = SettingsPathParams
  { settingsPathParamsApiVersion :: ApiVersion,
    settingsPathParamsDocument :: SettingsPathParamsDocument
  }
  deriving (Eq, Show)

instance FromJSON SettingsPathParams where parseJSON = checked "SettingsPathParams" $ withObject "SettingsPathParams" (\fields -> SettingsPathParams <$> (fields .: "apiVersion") <*> (fields .: "document"))

instance ToJSON SettingsPathParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (settingsPathParamsApiVersion value))], [("document", toJSON (settingsPathParamsDocument value))]]))

data SettingsPathParamsDocument = SettingsPathParamsDocumentBrowser | SettingsPathParamsDocumentWorker | SettingsPathParamsDocumentIssuer | SettingsPathParamsDocumentVectors deriving (Eq, Show)

instance FromJSON SettingsPathParamsDocument where parseJSON = checked "SettingsPathParamsDocument" $ \value -> if value == String "browser" then pure SettingsPathParamsDocumentBrowser else if value == String "worker" then pure SettingsPathParamsDocumentWorker else if value == String "issuer" then pure SettingsPathParamsDocumentIssuer else if value == String "vectors" then pure SettingsPathParamsDocumentVectors else fail "unknown enumeration member"

instance ToJSON SettingsPathParamsDocument where
  toJSON SettingsPathParamsDocumentBrowser = String "browser"
  toJSON SettingsPathParamsDocumentWorker = String "worker"
  toJSON SettingsPathParamsDocumentIssuer = String "issuer"
  toJSON SettingsPathParamsDocumentVectors = String "vectors"

settingsPathParamsDocumentText :: SettingsPathParamsDocument -> Text
settingsPathParamsDocumentText SettingsPathParamsDocumentBrowser = "browser"
settingsPathParamsDocumentText SettingsPathParamsDocumentWorker = "worker"
settingsPathParamsDocumentText SettingsPathParamsDocumentIssuer = "issuer"
settingsPathParamsDocumentText SettingsPathParamsDocumentVectors = "vectors"
