-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.OcrConfidence (OcrConfidence (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec

data OcrConfidence = OcrConfidence
  { ocrConfidenceLowConfidenceWords :: Integer,
    ocrConfidenceMean :: Scientific,
    ocrConfidenceTotalWords :: Integer
  }
  deriving (Eq, Show)

instance FromJSON OcrConfidence where parseJSON = checked "OcrConfidence" $ withObject "OcrConfidence" (\fields -> OcrConfidence <$> (fields .: "lowConfidenceWords") <*> (fields .: "mean") <*> (fields .: "totalWords"))

instance ToJSON OcrConfidence where toJSON value = Object (KM.fromList (concat [[("lowConfidenceWords", toJSON (ocrConfidenceLowConfidenceWords value))], [("mean", toJSON (ocrConfidenceMean value))], [("totalWords", toJSON (ocrConfidenceTotalWords value))]]))
