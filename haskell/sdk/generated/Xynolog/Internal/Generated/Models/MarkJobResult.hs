-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkJobResult (MarkJobResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobDeclined
import Xynolog.Internal.Generated.Models.MarkJobDone

data MarkJobResult = MarkJobResultMarkJobDone MarkJobDone | MarkJobResultJobDeclined JobDeclined deriving (Eq, Show)

instance FromJSON MarkJobResult where parseJSON = checked "MarkJobResult" $ \value -> readMember "MarkJobResult" [([Signature {signatureKind = ObjectKind, signatureRequired = ["found", "persisted"], signatureAllowed = Just ["found", "persisted", "errors", "byCategory", "underReportedPieces", "uncheckedPieces"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], MarkJobResultMarkJobDone <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["declined", "reason"], signatureAllowed = Just ["declined", "reason"], signatureFixed = [("declined", [Bool True]), ("reason", [String "no-text-layer", String "encrypted", String "corrupt", String "too-large", String "empty"])], signaturePattern = Nothing, signatureValues = Nothing}], MarkJobResultJobDeclined <$> parseJSON value)] value

instance ToJSON MarkJobResult where
  toJSON (MarkJobResultMarkJobDone value) = toJSON value
  toJSON (MarkJobResultJobDeclined value) = toJSON value
