-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.PdfClass (PdfClass (..), pdfClassText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data PdfClass = PdfClassA | PdfClassB | PdfClassC | PdfClassD | PdfClassE | PdfClassF | PdfClassG deriving (Eq, Show)

instance FromJSON PdfClass where parseJSON = checked "PdfClass" $ \value -> if value == String "A" then pure PdfClassA else if value == String "B" then pure PdfClassB else if value == String "C" then pure PdfClassC else if value == String "D" then pure PdfClassD else if value == String "E" then pure PdfClassE else if value == String "F" then pure PdfClassF else if value == String "G" then pure PdfClassG else fail "unknown enumeration member"

instance ToJSON PdfClass where
  toJSON PdfClassA = String "A"
  toJSON PdfClassB = String "B"
  toJSON PdfClassC = String "C"
  toJSON PdfClassD = String "D"
  toJSON PdfClassE = String "E"
  toJSON PdfClassF = String "F"
  toJSON PdfClassG = String "G"

pdfClassText :: PdfClass -> Text
pdfClassText PdfClassA = "A"
pdfClassText PdfClassB = "B"
pdfClassText PdfClassC = "C"
pdfClassText PdfClassD = "D"
pdfClassText PdfClassE = "E"
pdfClassText PdfClassF = "F"
pdfClassText PdfClassG = "G"
