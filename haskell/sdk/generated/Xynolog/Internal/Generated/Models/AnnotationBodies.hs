-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnnotationBodies (AnnotationBodies (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationBody

data AnnotationBodies = AnnotationBodiesAnnotationBody AnnotationBody | AnnotationBodiesList [AnnotationBody] deriving (Eq, Show)

instance FromJSON AnnotationBodies where parseJSON = checked "AnnotationBodies" $ \value -> readMember "AnnotationBodies" [([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "value"], signatureAllowed = Nothing, signatureFixed = [("type", [String "TextualBody"]), ("purpose", [String "assessing", String "bookmarking", String "classifying", String "commenting", String "describing", String "editing", String "highlighting", String "identifying", String "linking", String "moderating", String "questioning", String "replying", String "tagging"])], signaturePattern = Nothing, signatureValues = Nothing}, Signature {signatureKind = ObjectKind, signatureRequired = ["type", "source"], signatureAllowed = Nothing, signatureFixed = [("type", [String "SpecificResource"]), ("purpose", [String "assessing", String "bookmarking", String "classifying", String "commenting", String "describing", String "editing", String "highlighting", String "identifying", String "linking", String "moderating", String "questioning", String "replying", String "tagging"])], signaturePattern = Nothing, signatureValues = Nothing}], AnnotationBodiesAnnotationBody <$> parseJSON value), ([Signature {signatureKind = ListKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], AnnotationBodiesList <$> parseJSON value)] value

instance ToJSON AnnotationBodies where
  toJSON (AnnotationBodiesAnnotationBody value) = toJSON value
  toJSON (AnnotationBodiesList value) = toJSON value
