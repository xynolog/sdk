-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ExtractionDeclinedReason (ExtractionDeclinedReason (..), extractionDeclinedReasonText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data ExtractionDeclinedReason = ExtractionDeclinedReasonNoU2d_textU2d_layer | ExtractionDeclinedReasonEncrypted | ExtractionDeclinedReasonCorrupt | ExtractionDeclinedReasonTooU2d_large deriving (Eq, Show)

instance FromJSON ExtractionDeclinedReason where parseJSON = checked "ExtractionDeclinedReason" $ \value -> if value == String "no-text-layer" then pure ExtractionDeclinedReasonNoU2d_textU2d_layer else if value == String "encrypted" then pure ExtractionDeclinedReasonEncrypted else if value == String "corrupt" then pure ExtractionDeclinedReasonCorrupt else if value == String "too-large" then pure ExtractionDeclinedReasonTooU2d_large else fail "unknown enumeration member"

instance ToJSON ExtractionDeclinedReason where
  toJSON ExtractionDeclinedReasonNoU2d_textU2d_layer = String "no-text-layer"
  toJSON ExtractionDeclinedReasonEncrypted = String "encrypted"
  toJSON ExtractionDeclinedReasonCorrupt = String "corrupt"
  toJSON ExtractionDeclinedReasonTooU2d_large = String "too-large"

extractionDeclinedReasonText :: ExtractionDeclinedReason -> Text
extractionDeclinedReasonText ExtractionDeclinedReasonNoU2d_textU2d_layer = "no-text-layer"
extractionDeclinedReasonText ExtractionDeclinedReasonEncrypted = "encrypted"
extractionDeclinedReasonText ExtractionDeclinedReasonCorrupt = "corrupt"
extractionDeclinedReasonText ExtractionDeclinedReasonTooU2d_large = "too-large"
