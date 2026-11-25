-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BodyOperation (BodyOperation (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.BodyOperationAdd
import Xynolog.Internal.Generated.Models.BodyOperationRemove
import Xynolog.Internal.Generated.Models.BodyOperationReplace

data BodyOperation = BodyOperationBodyOperationAdd BodyOperationAdd | BodyOperationBodyOperationRemove BodyOperationRemove | BodyOperationBodyOperationReplace BodyOperationReplace deriving (Eq, Show)

instance FromJSON BodyOperation where parseJSON = checked "BodyOperation" $ \value -> readMember "BodyOperation" [([Signature {signatureKind = ObjectKind, signatureRequired = ["op", "item"], signatureAllowed = Nothing, signatureFixed = [("op", [String "add"])], signaturePattern = Nothing, signatureValues = Nothing}], BodyOperationBodyOperationAdd <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["op", "item"], signatureAllowed = Nothing, signatureFixed = [("op", [String "remove"])], signaturePattern = Nothing, signatureValues = Nothing}], BodyOperationBodyOperationRemove <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["op", "oldItem", "newItem"], signatureAllowed = Nothing, signatureFixed = [("op", [String "replace"])], signaturePattern = Nothing, signatureValues = Nothing}], BodyOperationBodyOperationReplace <$> parseJSON value)] value

instance ToJSON BodyOperation where
  toJSON (BodyOperationBodyOperationAdd value) = toJSON value
  toJSON (BodyOperationBodyOperationRemove value) = toJSON value
  toJSON (BodyOperationBodyOperationReplace value) = toJSON value
