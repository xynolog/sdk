-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnnotationSelector (AnnotationSelector (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Selector

data AnnotationSelector = AnnotationSelectorSelector Selector | AnnotationSelectorList [Selector] deriving (Eq, Show)

instance FromJSON AnnotationSelector where parseJSON = checked "AnnotationSelector" $ \value -> readMember "AnnotationSelector" [([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "start", "end"], signatureAllowed = Nothing, signatureFixed = [("type", [String "TextPositionSelector"])], signaturePattern = Nothing, signatureValues = Nothing}, Signature {signatureKind = ObjectKind, signatureRequired = ["type", "exact"], signatureAllowed = Nothing, signatureFixed = [("type", [String "TextQuoteSelector"])], signaturePattern = Nothing, signatureValues = Nothing}, Signature {signatureKind = ObjectKind, signatureRequired = ["type", "value"], signatureAllowed = Nothing, signatureFixed = [("type", [String "SvgSelector"])], signaturePattern = Nothing, signatureValues = Nothing}, Signature {signatureKind = ObjectKind, signatureRequired = ["type", "value"], signatureAllowed = Nothing, signatureFixed = [("type", [String "FragmentSelector"])], signaturePattern = Nothing, signatureValues = Nothing}], AnnotationSelectorSelector <$> parseJSON value), ([Signature {signatureKind = ListKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], AnnotationSelectorList <$> parseJSON value)] value

instance ToJSON AnnotationSelector where
  toJSON (AnnotationSelectorSelector value) = toJSON value
  toJSON (AnnotationSelectorList value) = toJSON value
