-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ExtractionOutcome (ExtractionOutcome (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ExtractedText
import Xynolog.Internal.Generated.Models.ExtractionDeclined

data ExtractionOutcome = ExtractionOutcomeExtractedText ExtractedText | ExtractionOutcomeExtractionDeclined ExtractionDeclined deriving (Eq, Show)

instance FromJSON ExtractionOutcome where parseJSON = checked "ExtractionOutcome" $ \value -> readMember "ExtractionOutcome" [([Signature {signatureKind = ObjectKind, signatureRequired = ["text", "items", "kind", "method"], signatureAllowed = Nothing, signatureFixed = [("kind", [String "extracted"]), ("method", [String "text-passthrough", String "pdf-text-layer", String "table", String "form", String "ocr"]), ("pdfClass", [String "A", String "B", String "C", String "D", String "E", String "F", String "G"])], signaturePattern = Nothing, signatureValues = Nothing}], ExtractionOutcomeExtractedText <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "declined"], signatureAllowed = Nothing, signatureFixed = [("kind", [String "declined"]), ("declined", [String "no-text-layer", String "encrypted", String "corrupt", String "too-large"])], signaturePattern = Nothing, signatureValues = Nothing}], ExtractionOutcomeExtractionDeclined <$> parseJSON value)] value

instance ToJSON ExtractionOutcome where
  toJSON (ExtractionOutcomeExtractedText value) = toJSON value
  toJSON (ExtractionOutcomeExtractionDeclined value) = toJSON value
