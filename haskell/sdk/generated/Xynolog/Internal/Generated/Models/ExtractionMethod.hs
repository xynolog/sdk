-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ExtractionMethod (ExtractionMethod (..), extractionMethodText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data ExtractionMethod = ExtractionMethodTextU2d_passthrough | ExtractionMethodPdfU2d_textU2d_layer | ExtractionMethodTable | ExtractionMethodForm | ExtractionMethodOcr deriving (Eq, Show)

instance FromJSON ExtractionMethod where parseJSON = checked "ExtractionMethod" $ \value -> if value == String "text-passthrough" then pure ExtractionMethodTextU2d_passthrough else if value == String "pdf-text-layer" then pure ExtractionMethodPdfU2d_textU2d_layer else if value == String "table" then pure ExtractionMethodTable else if value == String "form" then pure ExtractionMethodForm else if value == String "ocr" then pure ExtractionMethodOcr else fail "unknown enumeration member"

instance ToJSON ExtractionMethod where
  toJSON ExtractionMethodTextU2d_passthrough = String "text-passthrough"
  toJSON ExtractionMethodPdfU2d_textU2d_layer = String "pdf-text-layer"
  toJSON ExtractionMethodTable = String "table"
  toJSON ExtractionMethodForm = String "form"
  toJSON ExtractionMethodOcr = String "ocr"

extractionMethodText :: ExtractionMethod -> Text
extractionMethodText ExtractionMethodTextU2d_passthrough = "text-passthrough"
extractionMethodText ExtractionMethodPdfU2d_textU2d_layer = "pdf-text-layer"
extractionMethodText ExtractionMethodTable = "table"
extractionMethodText ExtractionMethodForm = "form"
extractionMethodText ExtractionMethodOcr = "ocr"
