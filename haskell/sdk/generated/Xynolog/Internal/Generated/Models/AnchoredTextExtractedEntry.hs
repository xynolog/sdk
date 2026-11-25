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
  { anchoredTextExtractedEntryV :: AnchoredTextExtractedEntryV,
    anchoredTextExtractedEntryStamp :: Text,
    anchoredTextExtractedEntryText :: Text,
    anchoredTextExtractedEntryLines :: [AnchoredTextExtractedEntryLinesItem],
    anchoredTextExtractedEntryMethod :: ExtractionMethod,
    anchoredTextExtractedEntryPdfClass :: Maybe PdfClass,
    anchoredTextExtractedEntryOcrConfidence :: Maybe OcrConfidence,
    anchoredTextExtractedEntryUnreadPages :: Maybe [Integer]
  }
  deriving (Eq, Show)

instance FromJSON AnchoredTextExtractedEntry where parseJSON = checked "AnchoredTextExtractedEntry" $ withObject "AnchoredTextExtractedEntry" (\fields -> AnchoredTextExtractedEntry <$> (fields .: "v") <*> (fields .: "stamp") <*> (fields .: "text") <*> (fields .: "lines") <*> (fields .: "method") <*> optional fields "pdfClass" <*> optional fields "ocrConfidence" <*> optional fields "unreadPages")

instance ToJSON AnchoredTextExtractedEntry where toJSON value = Object (KM.fromList (concat [[("v", toJSON (anchoredTextExtractedEntryV value))], [("stamp", toJSON (anchoredTextExtractedEntryStamp value))], [("text", toJSON (anchoredTextExtractedEntryText value))], [("lines", toJSON (anchoredTextExtractedEntryLines value))], [("method", toJSON (anchoredTextExtractedEntryMethod value))], optionalPair "pdfClass" (anchoredTextExtractedEntryPdfClass value), optionalPair "ocrConfidence" (anchoredTextExtractedEntryOcrConfidence value), optionalPair "unreadPages" (anchoredTextExtractedEntryUnreadPages value)]))

data AnchoredTextExtractedEntryLinesItem = AnchoredTextExtractedEntryLinesItem
  { anchoredTextExtractedEntryLinesItemP :: Integer,
    anchoredTextExtractedEntryLinesItemY :: Scientific,
    anchoredTextExtractedEntryLinesItemH :: Scientific,
    anchoredTextExtractedEntryLinesItemWords :: [[Scientific]]
  }
  deriving (Eq, Show)

instance FromJSON AnchoredTextExtractedEntryLinesItem where parseJSON = checked "AnchoredTextExtractedEntryLinesItem" $ withObject "AnchoredTextExtractedEntryLinesItem" (\fields -> AnchoredTextExtractedEntryLinesItem <$> (fields .: "p") <*> (fields .: "y") <*> (fields .: "h") <*> (fields .: "words"))

instance ToJSON AnchoredTextExtractedEntryLinesItem where toJSON value = Object (KM.fromList (concat [[("p", toJSON (anchoredTextExtractedEntryLinesItemP value))], [("y", toJSON (anchoredTextExtractedEntryLinesItemY value))], [("h", toJSON (anchoredTextExtractedEntryLinesItemH value))], [("words", toJSON (anchoredTextExtractedEntryLinesItemWords value))]]))

data AnchoredTextExtractedEntryV = AnchoredTextExtractedEntryV3 deriving (Eq, Show)

instance FromJSON AnchoredTextExtractedEntryV where parseJSON = checked "AnchoredTextExtractedEntryV" $ \value -> if value == Number (read "3.0") then pure AnchoredTextExtractedEntryV3 else fail "unknown enumeration member"

instance ToJSON AnchoredTextExtractedEntryV where toJSON AnchoredTextExtractedEntryV3 = Number (read "3.0")
