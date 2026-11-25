-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchoredTextAnswer (AnchoredTextAnswer (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnchoredTextAbsent
import Xynolog.Internal.Generated.Models.ExtractedText
import Xynolog.Internal.Generated.Models.ExtractionDeclined

data AnchoredTextAnswer = AnchoredTextAnswerExtractedText ExtractedText | AnchoredTextAnswerExtractionDeclined ExtractionDeclined | AnchoredTextAnswerAnchoredTextAbsent AnchoredTextAbsent deriving (Eq, Show)

instance FromJSON AnchoredTextAnswer where parseJSON = checked "AnchoredTextAnswer" $ \value -> readMember "AnchoredTextAnswer" [([Signature {signatureKind = ObjectKind, signatureRequired = ["text", "items", "kind", "method"], signatureAllowed = Nothing, signatureFixed = [("kind", [String "extracted"]), ("method", [String "text-passthrough", String "pdf-text-layer", String "table", String "form", String "ocr"]), ("pdfClass", [String "A", String "B", String "C", String "D", String "E", String "F", String "G"])], signaturePattern = Nothing, signatureValues = Nothing}], AnchoredTextAnswerExtractedText <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "declined"], signatureAllowed = Nothing, signatureFixed = [("kind", [String "declined"]), ("declined", [String "no-text-layer", String "encrypted", String "corrupt", String "too-large"])], signaturePattern = Nothing, signatureValues = Nothing}], AnchoredTextAnswerExtractionDeclined <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind"], signatureAllowed = Nothing, signatureFixed = [("kind", [String "not-yet", String "no-map", String "unknown"])], signaturePattern = Nothing, signatureValues = Nothing}], AnchoredTextAnswerAnchoredTextAbsent <$> parseJSON value)] value

instance ToJSON AnchoredTextAnswer where
  toJSON (AnchoredTextAnswerExtractedText value) = toJSON value
  toJSON (AnchoredTextAnswerExtractionDeclined value) = toJSON value
  toJSON (AnchoredTextAnswerAnchoredTextAbsent value) = toJSON value
