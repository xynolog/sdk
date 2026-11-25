-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.PdfTextItem (PdfTextItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec

data PdfTextItem = PdfTextItem
  { pdfTextItemEnd :: Integer,
    pdfTextItemHeight :: Scientific,
    pdfTextItemPage :: Integer,
    pdfTextItemStart :: Integer,
    pdfTextItemWidth :: Scientific,
    pdfTextItemX :: Scientific,
    pdfTextItemY :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON PdfTextItem where parseJSON = checked "PdfTextItem" $ withObject "PdfTextItem" (\fields -> PdfTextItem <$> (fields .: "end") <*> (fields .: "height") <*> (fields .: "page") <*> (fields .: "start") <*> (fields .: "width") <*> (fields .: "x") <*> (fields .: "y"))

instance ToJSON PdfTextItem where toJSON value = Object (KM.fromList (concat [[("end", toJSON (pdfTextItemEnd value))], [("height", toJSON (pdfTextItemHeight value))], [("page", toJSON (pdfTextItemPage value))], [("start", toJSON (pdfTextItemStart value))], [("width", toJSON (pdfTextItemWidth value))], [("x", toJSON (pdfTextItemX value))], [("y", toJSON (pdfTextItemY value))]]))
