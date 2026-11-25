-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchoredTextEntry (AnchoredTextEntry (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnchoredTextDeclinedEntry
import Xynolog.Internal.Generated.Models.AnchoredTextExtractedEntry

data AnchoredTextEntry = AnchoredTextEntryAnchoredTextExtractedEntry AnchoredTextExtractedEntry | AnchoredTextEntryAnchoredTextDeclinedEntry AnchoredTextDeclinedEntry deriving (Eq, Show)

instance FromJSON AnchoredTextEntry where parseJSON = checked "AnchoredTextEntry" $ \value -> readMember "AnchoredTextEntry" [([Signature {signatureKind = ObjectKind, signatureRequired = ["v", "stamp", "text", "lines", "method"], signatureAllowed = Just ["v", "stamp", "text", "lines", "method", "pdfClass", "ocrConfidence", "unreadPages"], signatureFixed = [("v", [Number (read "3.0")]), ("method", [String "text-passthrough", String "pdf-text-layer", String "table", String "form", String "ocr"]), ("pdfClass", [String "A", String "B", String "C", String "D", String "E", String "F", String "G"])], signaturePattern = Nothing, signatureValues = Nothing}], AnchoredTextEntryAnchoredTextExtractedEntry <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["v", "stamp", "declined"], signatureAllowed = Just ["v", "stamp", "declined"], signatureFixed = [("v", [Number (read "3.0")]), ("declined", [String "no-text-layer", String "encrypted", String "corrupt", String "too-large"])], signaturePattern = Nothing, signatureValues = Nothing}], AnchoredTextEntryAnchoredTextDeclinedEntry <$> parseJSON value)] value

instance ToJSON AnchoredTextEntry where
  toJSON (AnchoredTextEntryAnchoredTextExtractedEntry value) = toJSON value
  toJSON (AnchoredTextEntryAnchoredTextDeclinedEntry value) = toJSON value
