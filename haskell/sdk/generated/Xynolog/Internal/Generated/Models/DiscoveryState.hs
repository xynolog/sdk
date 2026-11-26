-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryState (DiscoveryState (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveryAbsent
import Xynolog.Internal.Generated.Models.DiscoveryManaged

data DiscoveryState = DiscoveryStateDiscoveryAbsent DiscoveryAbsent | DiscoveryStateDiscoveryManaged DiscoveryManaged deriving (Eq, Show)

instance FromJSON DiscoveryState where parseJSON = checked "DiscoveryState" $ \value -> readMember "DiscoveryState" [([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "reason"], signatureAllowed = Just ["kind", "reason", "diagnostic"], signatureFixed = [("kind", [String "absent"])], signaturePattern = Nothing, signatureValues = Nothing}], DiscoveryStateDiscoveryAbsent <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "kbs"], signatureAllowed = Just ["kind", "kbs"], signatureFixed = [("kind", [String "managed"])], signaturePattern = Nothing, signatureValues = Nothing}], DiscoveryStateDiscoveryManaged <$> parseJSON value)] value

instance ToJSON DiscoveryState where
  toJSON (DiscoveryStateDiscoveryAbsent value) = toJSON value
  toJSON (DiscoveryStateDiscoveryManaged value) = toJSON value
