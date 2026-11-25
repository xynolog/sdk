-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchoredTextExtractedEntry (AnchoredTextExtractedEntry (..), AnchoredTextExtractedEntryLinesItem (..), AnchoredTextExtractedEntryV (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ExtractionMethod
import Xynolog.Internal.Generated.Models.OcrConfidence
import Xynolog.Internal.Generated.Models.PdfClass

data AnchoredTextExtractedEntry = AnchoredTextExtractedEntry
  { anchoredTextExtractedEntryLines :: [AnchoredTextExtractedEntryLinesItem],
    anchoredTextExtractedEntryMethod :: ExtractionMethod,
    anchoredTextExtractedEntryOcrConfidence :: Maybe OcrConfidence,
    anchoredTextExtractedEntryPdfClass :: Maybe PdfClass,
    anchoredTextExtractedEntryStamp :: Text,
    anchoredTextExtractedEntryText :: Text,
    anchoredTextExtractedEntryUnreadPages :: Maybe [Integer],
    anchoredTextExtractedEntryV :: AnchoredTextExtractedEntryV
  }
  deriving (Eq, Show)

instance FromJSON AnchoredTextExtractedEntry where parseJSON = checked "AnchoredTextExtractedEntry" $ withObject "AnchoredTextExtractedEntry" (\fields -> AnchoredTextExtractedEntry <$> (fields .: "lines") <*> (fields .: "method") <*> optional fields "ocrConfidence" <*> optional fields "pdfClass" <*> (fields .: "stamp") <*> (fields .: "text") <*> optional fields "unreadPages" <*> (fields .: "v"))

instance ToJSON AnchoredTextExtractedEntry where toJSON value = Object (KM.fromList (concat [[("lines", toJSON (anchoredTextExtractedEntryLines value))], [("method", toJSON (anchoredTextExtractedEntryMethod value))], optionalPair "ocrConfidence" (anchoredTextExtractedEntryOcrConfidence value), optionalPair "pdfClass" (anchoredTextExtractedEntryPdfClass value), [("stamp", toJSON (anchoredTextExtractedEntryStamp value))], [("text", toJSON (anchoredTextExtractedEntryText value))], optionalPair "unreadPages" (anchoredTextExtractedEntryUnreadPages value), [("v", toJSON (anchoredTextExtractedEntryV value))]]))

data AnchoredTextExtractedEntryLinesItem = AnchoredTextExtractedEntryLinesItem
  { anchoredTextExtractedEntryLinesItemH :: Scientific,
    anchoredTextExtractedEntryLinesItemP :: Integer,
    anchoredTextExtractedEntryLinesItemWords :: [[Scientific]],
    anchoredTextExtractedEntryLinesItemY :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON AnchoredTextExtractedEntryLinesItem where parseJSON = checked "AnchoredTextExtractedEntryLinesItem" $ withObject "AnchoredTextExtractedEntryLinesItem" (\fields -> AnchoredTextExtractedEntryLinesItem <$> (fields .: "h") <*> (fields .: "p") <*> (fields .: "words") <*> (fields .: "y"))

instance ToJSON AnchoredTextExtractedEntryLinesItem where toJSON value = Object (KM.fromList (concat [[("h", toJSON (anchoredTextExtractedEntryLinesItemH value))], [("p", toJSON (anchoredTextExtractedEntryLinesItemP value))], [("words", toJSON (anchoredTextExtractedEntryLinesItemWords value))], [("y", toJSON (anchoredTextExtractedEntryLinesItemY value))]]))

data AnchoredTextExtractedEntryV = AnchoredTextExtractedEntryV3 deriving (Eq, Show)

instance FromJSON AnchoredTextExtractedEntryV where parseJSON = checked "AnchoredTextExtractedEntryV" $ \value -> if value == Number (read "3.0") then pure AnchoredTextExtractedEntryV3 else fail "unknown enumeration member"

instance ToJSON AnchoredTextExtractedEntryV where toJSON AnchoredTextExtractedEntryV3 = Number (read "3.0")
