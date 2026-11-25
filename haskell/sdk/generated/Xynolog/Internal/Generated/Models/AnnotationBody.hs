-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnnotationBody (AnnotationBody (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.SpecificResource
import Xynolog.Internal.Generated.Models.TextualBody

data AnnotationBody = AnnotationBodyTextualBody TextualBody | AnnotationBodySpecificResource SpecificResource deriving (Eq, Show)

instance FromJSON AnnotationBody where parseJSON = checked "AnnotationBody" $ \value -> readMember "AnnotationBody" [([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "value"], signatureAllowed = Nothing, signatureFixed = [("type", [String "TextualBody"]), ("purpose", [String "assessing", String "bookmarking", String "classifying", String "commenting", String "describing", String "editing", String "highlighting", String "identifying", String "linking", String "moderating", String "questioning", String "replying", String "tagging"])], signaturePattern = Nothing, signatureValues = Nothing}], AnnotationBodyTextualBody <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "source"], signatureAllowed = Nothing, signatureFixed = [("type", [String "SpecificResource"]), ("purpose", [String "assessing", String "bookmarking", String "classifying", String "commenting", String "describing", String "editing", String "highlighting", String "identifying", String "linking", String "moderating", String "questioning", String "replying", String "tagging"])], signaturePattern = Nothing, signatureValues = Nothing}], AnnotationBodySpecificResource <$> parseJSON value)] value

instance ToJSON AnnotationBody where
  toJSON (AnnotationBodyTextualBody value) = toJSON value
  toJSON (AnnotationBodySpecificResource value) = toJSON value
