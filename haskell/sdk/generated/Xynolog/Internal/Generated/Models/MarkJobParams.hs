-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkJobParams (MarkJobParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AssessingJobParams
import Xynolog.Internal.Generated.Models.CommentingJobParams
import Xynolog.Internal.Generated.Models.HighlightingJobParams
import Xynolog.Internal.Generated.Models.LinkingJobParams
import Xynolog.Internal.Generated.Models.TaggingJobParams

data MarkJobParams = MarkJobParamsHighlightingJobParams HighlightingJobParams | MarkJobParamsCommentingJobParams CommentingJobParams | MarkJobParamsAssessingJobParams AssessingJobParams | MarkJobParamsLinkingJobParams LinkingJobParams | MarkJobParamsTaggingJobParams TaggingJobParams deriving (Eq, Show)

instance FromJSON MarkJobParams where parseJSON = checked "MarkJobParams" $ \value -> readMember "MarkJobParams" [([Signature {signatureKind = ObjectKind, signatureRequired = ["motivation"], signatureAllowed = Just ["motivation", "instructions", "density", "sourceLanguage"], signatureFixed = [("motivation", [String "highlighting"])], signaturePattern = Nothing, signatureValues = Nothing}], MarkJobParamsHighlightingJobParams <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["motivation"], signatureAllowed = Just ["motivation", "instructions", "tone", "density", "language", "sourceLanguage"], signatureFixed = [("motivation", [String "commenting"]), ("tone", [String "scholarly", String "explanatory", String "conversational", String "technical"])], signaturePattern = Nothing, signatureValues = Nothing}], MarkJobParamsCommentingJobParams <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["motivation"], signatureAllowed = Just ["motivation", "instructions", "tone", "density", "language", "sourceLanguage"], signatureFixed = [("motivation", [String "assessing"]), ("tone", [String "analytical", String "critical", String "balanced", String "constructive"])], signaturePattern = Nothing, signatureValues = Nothing}], MarkJobParamsAssessingJobParams <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["motivation", "entityTypes"], signatureAllowed = Just ["motivation", "entityTypes", "includeDescriptiveReferences", "language", "sourceLanguage"], signatureFixed = [("motivation", [String "linking"])], signaturePattern = Nothing, signatureValues = Nothing}], MarkJobParamsLinkingJobParams <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["motivation", "schemaId", "categories"], signatureAllowed = Just ["motivation", "schemaId", "categories", "language", "sourceLanguage"], signatureFixed = [("motivation", [String "tagging"])], signaturePattern = Nothing, signatureValues = Nothing}], MarkJobParamsTaggingJobParams <$> parseJSON value)] value

instance ToJSON MarkJobParams where
  toJSON (MarkJobParamsHighlightingJobParams value) = toJSON value
  toJSON (MarkJobParamsCommentingJobParams value) = toJSON value
  toJSON (MarkJobParamsAssessingJobParams value) = toJSON value
  toJSON (MarkJobParamsLinkingJobParams value) = toJSON value
  toJSON (MarkJobParamsTaggingJobParams value) = toJSON value
