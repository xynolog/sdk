-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Selector (Selector (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FragmentSelector
import Xynolog.Internal.Generated.Models.SvgSelector
import Xynolog.Internal.Generated.Models.TextPositionSelector
import Xynolog.Internal.Generated.Models.TextQuoteSelector

data Selector = SelectorTextPositionSelector TextPositionSelector | SelectorTextQuoteSelector TextQuoteSelector | SelectorSvgSelector SvgSelector | SelectorFragmentSelector FragmentSelector deriving (Eq, Show)

instance FromJSON Selector where parseJSON = checked "Selector" $ \value -> readMember "Selector" [([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "start", "end"], signatureAllowed = Nothing, signatureFixed = [("type", [String "TextPositionSelector"])], signaturePattern = Nothing, signatureValues = Nothing}], SelectorTextPositionSelector <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "exact"], signatureAllowed = Nothing, signatureFixed = [("type", [String "TextQuoteSelector"])], signaturePattern = Nothing, signatureValues = Nothing}], SelectorTextQuoteSelector <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "value"], signatureAllowed = Nothing, signatureFixed = [("type", [String "SvgSelector"])], signaturePattern = Nothing, signatureValues = Nothing}], SelectorSvgSelector <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "value"], signatureAllowed = Nothing, signatureFixed = [("type", [String "FragmentSelector"])], signaturePattern = Nothing, signatureValues = Nothing}], SelectorFragmentSelector <$> parseJSON value)] value

instance ToJSON Selector where
  toJSON (SelectorTextPositionSelector value) = toJSON value
  toJSON (SelectorTextQuoteSelector value) = toJSON value
  toJSON (SelectorSvgSelector value) = toJSON value
  toJSON (SelectorFragmentSelector value) = toJSON value
