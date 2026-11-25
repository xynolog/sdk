-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ExtractedText (ExtractedText (..), ExtractedTextKind (..), extractedTextKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ExtractionMethod
import Xynolog.Internal.Generated.Models.OcrConfidence
import Xynolog.Internal.Generated.Models.PdfClass
import Xynolog.Internal.Generated.Models.PdfTextItem

data ExtractedText = ExtractedText
  { extractedTextText :: Text,
    extractedTextItems :: [PdfTextItem],
    extractedTextKind :: ExtractedTextKind,
    extractedTextMethod :: ExtractionMethod,
    extractedTextPdfClass :: Maybe PdfClass,
    extractedTextOcrConfidence :: Maybe OcrConfidence,
    extractedTextUnreadPages :: Maybe [Integer]
  }
  deriving (Eq, Show)

instance FromJSON ExtractedText where parseJSON = checked "ExtractedText" $ withObject "ExtractedText" (\fields -> ExtractedText <$> (fields .: "text") <*> (fields .: "items") <*> (fields .: "kind") <*> (fields .: "method") <*> optional fields "pdfClass" <*> optional fields "ocrConfidence" <*> optional fields "unreadPages")

instance ToJSON ExtractedText where toJSON value = Object (KM.fromList (concat [[("text", toJSON (extractedTextText value))], [("items", toJSON (extractedTextItems value))], [("kind", toJSON (extractedTextKind value))], [("method", toJSON (extractedTextMethod value))], optionalPair "pdfClass" (extractedTextPdfClass value), optionalPair "ocrConfidence" (extractedTextOcrConfidence value), optionalPair "unreadPages" (extractedTextUnreadPages value)]))

data ExtractedTextKind = ExtractedTextKindExtracted deriving (Eq, Show)

instance FromJSON ExtractedTextKind where parseJSON = checked "ExtractedTextKind" $ \value -> if value == String "extracted" then pure ExtractedTextKindExtracted else fail "unknown enumeration member"

instance ToJSON ExtractedTextKind where toJSON ExtractedTextKindExtracted = String "extracted"

extractedTextKindText :: ExtractedTextKind -> Text
extractedTextKindText ExtractedTextKindExtracted = "extracted"
