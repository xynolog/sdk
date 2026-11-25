-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.PdfTextItem (PdfTextItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec

data PdfTextItem = PdfTextItem
  { pdfTextItemStart :: Integer,
    pdfTextItemEnd :: Integer,
    pdfTextItemPage :: Integer,
    pdfTextItemX :: Scientific,
    pdfTextItemY :: Scientific,
    pdfTextItemWidth :: Scientific,
    pdfTextItemHeight :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON PdfTextItem where parseJSON = checked "PdfTextItem" $ withObject "PdfTextItem" (\fields -> PdfTextItem <$> (fields .: "start") <*> (fields .: "end") <*> (fields .: "page") <*> (fields .: "x") <*> (fields .: "y") <*> (fields .: "width") <*> (fields .: "height"))

instance ToJSON PdfTextItem where toJSON value = Object (KM.fromList (concat [[("start", toJSON (pdfTextItemStart value))], [("end", toJSON (pdfTextItemEnd value))], [("page", toJSON (pdfTextItemPage value))], [("x", toJSON (pdfTextItemX value))], [("y", toJSON (pdfTextItemY value))], [("width", toJSON (pdfTextItemWidth value))], [("height", toJSON (pdfTextItemHeight value))]]))
