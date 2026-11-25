-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ExtractionDeclinedReason (ExtractionDeclinedReason (..), extractionDeclinedReasonText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data ExtractionDeclinedReason = ExtractionDeclinedReasonNoTextLayer | ExtractionDeclinedReasonEncrypted | ExtractionDeclinedReasonCorrupt | ExtractionDeclinedReasonTooLarge deriving (Eq, Show)

instance FromJSON ExtractionDeclinedReason where parseJSON = checked "ExtractionDeclinedReason" $ \value -> if value == String "no-text-layer" then pure ExtractionDeclinedReasonNoTextLayer else if value == String "encrypted" then pure ExtractionDeclinedReasonEncrypted else if value == String "corrupt" then pure ExtractionDeclinedReasonCorrupt else if value == String "too-large" then pure ExtractionDeclinedReasonTooLarge else fail "unknown enumeration member"

instance ToJSON ExtractionDeclinedReason where
  toJSON ExtractionDeclinedReasonNoTextLayer = String "no-text-layer"
  toJSON ExtractionDeclinedReasonEncrypted = String "encrypted"
  toJSON ExtractionDeclinedReasonCorrupt = String "corrupt"
  toJSON ExtractionDeclinedReasonTooLarge = String "too-large"

extractionDeclinedReasonText :: ExtractionDeclinedReason -> Text
extractionDeclinedReasonText ExtractionDeclinedReasonNoTextLayer = "no-text-layer"
extractionDeclinedReasonText ExtractionDeclinedReasonEncrypted = "encrypted"
extractionDeclinedReasonText ExtractionDeclinedReasonCorrupt = "corrupt"
extractionDeclinedReasonText ExtractionDeclinedReasonTooLarge = "too-large"
