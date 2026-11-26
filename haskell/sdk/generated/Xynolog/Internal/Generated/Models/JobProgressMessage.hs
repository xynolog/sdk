-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressMessage (JobProgressMessage (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobProgressAnalyzing
import Xynolog.Internal.Generated.Models.JobProgressAnalyzingTags
import Xynolog.Internal.Generated.Models.JobProgressCompleteCreated
import Xynolog.Internal.Generated.Models.JobProgressCompleteGenerated
import Xynolog.Internal.Generated.Models.JobProgressCreatingAnnotations
import Xynolog.Internal.Generated.Models.JobProgressCreatingResource
import Xynolog.Internal.Generated.Models.JobProgressCreatingTagAnnotations
import Xynolog.Internal.Generated.Models.JobProgressDetectingEntities
import Xynolog.Internal.Generated.Models.JobProgressGeneratingResource
import Xynolog.Internal.Generated.Models.JobProgressLoading

data JobProgressMessage = JobProgressMessageJobProgressLoading JobProgressLoading | JobProgressMessageJobProgressAnalyzing JobProgressAnalyzing | JobProgressMessageJobProgressAnalyzingTags JobProgressAnalyzingTags | JobProgressMessageJobProgressGeneratingResource JobProgressGeneratingResource | JobProgressMessageJobProgressCreatingResource JobProgressCreatingResource | JobProgressMessageJobProgressCompleteGenerated JobProgressCompleteGenerated | JobProgressMessageJobProgressDetectingEntities JobProgressDetectingEntities | JobProgressMessageJobProgressCreatingAnnotations JobProgressCreatingAnnotations | JobProgressMessageJobProgressCreatingTagAnnotations JobProgressCreatingTagAnnotations | JobProgressMessageJobProgressCompleteCreated JobProgressCompleteCreated deriving (Eq, Show)

instance FromJSON JobProgressMessage where parseJSON = checked "JobProgressMessage" $ \value -> readMember "JobProgressMessage" [([Signature {signatureKind = ObjectKind, signatureRequired = ["code"], signatureAllowed = Nothing, signatureFixed = [("code", [String "loading"])], signaturePattern = Nothing, signatureValues = Nothing}], JobProgressMessageJobProgressLoading <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code"], signatureAllowed = Nothing, signatureFixed = [("code", [String "analyzing"])], signaturePattern = Nothing, signatureValues = Nothing}], JobProgressMessageJobProgressAnalyzing <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code"], signatureAllowed = Nothing, signatureFixed = [("code", [String "analyzing-tags"])], signaturePattern = Nothing, signatureValues = Nothing}], JobProgressMessageJobProgressAnalyzingTags <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code"], signatureAllowed = Nothing, signatureFixed = [("code", [String "generating-resource"])], signaturePattern = Nothing, signatureValues = Nothing}], JobProgressMessageJobProgressGeneratingResource <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code"], signatureAllowed = Nothing, signatureFixed = [("code", [String "creating-resource"])], signaturePattern = Nothing, signatureValues = Nothing}], JobProgressMessageJobProgressCreatingResource <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "truncated"], signatureAllowed = Nothing, signatureFixed = [("code", [String "complete-generated"])], signaturePattern = Nothing, signatureValues = Nothing}], JobProgressMessageJobProgressCompleteGenerated <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "entityType"], signatureAllowed = Nothing, signatureFixed = [("code", [String "detecting-entities"])], signaturePattern = Nothing, signatureValues = Nothing}], JobProgressMessageJobProgressDetectingEntities <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "count"], signatureAllowed = Nothing, signatureFixed = [("code", [String "creating-annotations"])], signaturePattern = Nothing, signatureValues = Nothing}], JobProgressMessageJobProgressCreatingAnnotations <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "count"], signatureAllowed = Nothing, signatureFixed = [("code", [String "creating-tag-annotations"])], signaturePattern = Nothing, signatureValues = Nothing}], JobProgressMessageJobProgressCreatingTagAnnotations <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "count", "motivation"], signatureAllowed = Nothing, signatureFixed = [("code", [String "complete-created"]), ("motivation", [String "assessing", String "commenting", String "highlighting", String "linking", String "tagging"])], signaturePattern = Nothing, signatureValues = Nothing}], JobProgressMessageJobProgressCompleteCreated <$> parseJSON value)] value

instance ToJSON JobProgressMessage where
  toJSON (JobProgressMessageJobProgressLoading value) = toJSON value
  toJSON (JobProgressMessageJobProgressAnalyzing value) = toJSON value
  toJSON (JobProgressMessageJobProgressAnalyzingTags value) = toJSON value
  toJSON (JobProgressMessageJobProgressGeneratingResource value) = toJSON value
  toJSON (JobProgressMessageJobProgressCreatingResource value) = toJSON value
  toJSON (JobProgressMessageJobProgressCompleteGenerated value) = toJSON value
  toJSON (JobProgressMessageJobProgressDetectingEntities value) = toJSON value
  toJSON (JobProgressMessageJobProgressCreatingAnnotations value) = toJSON value
  toJSON (JobProgressMessageJobProgressCreatingTagAnnotations value) = toJSON value
  toJSON (JobProgressMessageJobProgressCompleteCreated value) = toJSON value
