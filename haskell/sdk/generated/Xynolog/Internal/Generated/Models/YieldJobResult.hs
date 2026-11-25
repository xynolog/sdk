-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldJobResult (YieldJobResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobDeclined
import Xynolog.Internal.Generated.Models.YieldJobDone

data YieldJobResult = YieldJobResultYieldJobDone YieldJobDone | YieldJobResultJobDeclined JobDeclined deriving (Eq, Show)

instance FromJSON YieldJobResult where parseJSON = checked "YieldJobResult" $ \value -> readMember "YieldJobResult" [([Signature {signatureKind = ObjectKind, signatureRequired = ["resourceId", "resourceName", "truncated"], signatureAllowed = Just ["resourceId", "resourceName", "truncated"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], YieldJobResultYieldJobDone <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["declined", "reason"], signatureAllowed = Just ["declined", "reason"], signatureFixed = [("declined", [Bool True]), ("reason", [String "no-text-layer", String "encrypted", String "corrupt", String "too-large", String "empty"])], signaturePattern = Nothing, signatureValues = Nothing}], YieldJobResultJobDeclined <$> parseJSON value)] value

instance ToJSON YieldJobResult where
  toJSON (YieldJobResultYieldJobDone value) = toJSON value
  toJSON (YieldJobResultJobDeclined value) = toJSON value
