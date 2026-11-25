-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ExtractionMethod (ExtractionMethod (..), extractionMethodText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data ExtractionMethod = ExtractionMethodTextPassthrough | ExtractionMethodPdfTextLayer | ExtractionMethodTable | ExtractionMethodForm | ExtractionMethodOcr deriving (Eq, Show)

instance FromJSON ExtractionMethod where parseJSON = checked "ExtractionMethod" $ \value -> if value == String "text-passthrough" then pure ExtractionMethodTextPassthrough else if value == String "pdf-text-layer" then pure ExtractionMethodPdfTextLayer else if value == String "table" then pure ExtractionMethodTable else if value == String "form" then pure ExtractionMethodForm else if value == String "ocr" then pure ExtractionMethodOcr else fail "unknown enumeration member"

instance ToJSON ExtractionMethod where
  toJSON ExtractionMethodTextPassthrough = String "text-passthrough"
  toJSON ExtractionMethodPdfTextLayer = String "pdf-text-layer"
  toJSON ExtractionMethodTable = String "table"
  toJSON ExtractionMethodForm = String "form"
  toJSON ExtractionMethodOcr = String "ocr"

extractionMethodText :: ExtractionMethod -> Text
extractionMethodText ExtractionMethodTextPassthrough = "text-passthrough"
extractionMethodText ExtractionMethodPdfTextLayer = "pdf-text-layer"
extractionMethodText ExtractionMethodTable = "table"
extractionMethodText ExtractionMethodForm = "form"
extractionMethodText ExtractionMethodOcr = "ocr"
