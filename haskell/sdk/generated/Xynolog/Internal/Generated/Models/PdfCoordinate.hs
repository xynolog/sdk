-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.PdfCoordinate (PdfCoordinate (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec

data PdfCoordinate = PdfCoordinate
  { pdfCoordinatePage :: Integer,
    pdfCoordinateX :: Scientific,
    pdfCoordinateY :: Scientific,
    pdfCoordinateWidth :: Scientific,
    pdfCoordinateHeight :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON PdfCoordinate where parseJSON = checked "PdfCoordinate" $ withObject "PdfCoordinate" (\fields -> PdfCoordinate <$> (fields .: "page") <*> (fields .: "x") <*> (fields .: "y") <*> (fields .: "width") <*> (fields .: "height"))

instance ToJSON PdfCoordinate where toJSON value = Object (KM.fromList (concat [[("page", toJSON (pdfCoordinatePage value))], [("x", toJSON (pdfCoordinateX value))], [("y", toJSON (pdfCoordinateY value))], [("width", toJSON (pdfCoordinateWidth value))], [("height", toJSON (pdfCoordinateHeight value))]]))
