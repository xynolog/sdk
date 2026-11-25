-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GetOpenApiDocumentResponse (GetOpenApiDocumentResponse (..), GetOpenApiDocumentResponseInfo (..), GetOpenApiDocumentResponsePaths (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data GetOpenApiDocumentResponse = GetOpenApiDocumentResponse
  { getOpenApiDocumentResponseOpenapi :: Text,
    getOpenApiDocumentResponseInfo :: GetOpenApiDocumentResponseInfo,
    getOpenApiDocumentResponsePaths :: GetOpenApiDocumentResponsePaths
  }
  deriving (Eq, Show)

instance FromJSON GetOpenApiDocumentResponse where parseJSON = checked "GetOpenApiDocumentResponse" $ withObject "GetOpenApiDocumentResponse" (\fields -> GetOpenApiDocumentResponse <$> (fields .: "openapi") <*> (fields .: "info") <*> (fields .: "paths"))

instance ToJSON GetOpenApiDocumentResponse where toJSON value = Object (KM.fromList (concat [[("openapi", toJSON (getOpenApiDocumentResponseOpenapi value))], [("info", toJSON (getOpenApiDocumentResponseInfo value))], [("paths", toJSON (getOpenApiDocumentResponsePaths value))]]))

data GetOpenApiDocumentResponseInfo = GetOpenApiDocumentResponseInfo
  { getOpenApiDocumentResponseInfoAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GetOpenApiDocumentResponseInfo where parseJSON = checked "GetOpenApiDocumentResponseInfo" $ withObject "GetOpenApiDocumentResponseInfo" (\fields -> GetOpenApiDocumentResponseInfo <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON GetOpenApiDocumentResponseInfo where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (getOpenApiDocumentResponseInfoAdditionalProperties value)))

data GetOpenApiDocumentResponsePaths = GetOpenApiDocumentResponsePaths
  { getOpenApiDocumentResponsePathsAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON GetOpenApiDocumentResponsePaths where parseJSON = checked "GetOpenApiDocumentResponsePaths" $ withObject "GetOpenApiDocumentResponsePaths" (\fields -> GetOpenApiDocumentResponsePaths <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON GetOpenApiDocumentResponsePaths where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (getOpenApiDocumentResponsePathsAdditionalProperties value)))
